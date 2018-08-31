defmodule Wsdjs.Jobs.NowPlaying do
  @moduledoc """
  Retrieves from the radioking API datas for the current played song.
  """
  require Logger
  require DateTime

  use GenServer
  use Timex
  use HTTPoison.Base

  alias Phoenix.PubSub

  @expected_fields ~w(
    title artist album cover started_at end_at duration buy_link
  )

  def start_link(name \\ nil) do
    queue = :queue.new()
    GenServer.start_link(__MODULE__, queue, name: name)
  end

  def init(state) do
    # Schedule work to be performed at some point
    schedule_work(5000)
    {:ok, state}
  end

  def read(pid) do
    GenServer.call(pid, {:read})
  end

  def handle_call({:read}, _, queue) do
    list = :queue.to_list(queue)
    {:reply, Enum.reverse(list), queue}
  end

  @radioking_api_uri "https://www.radioking.com/widgets/currenttrack.php?radio=84322&format=json"
  def handle_info(:work, queue) do
    queue =
      if :queue.len(queue) < 9 do
        list_broadcasted(queue)
      else
        queue
      end

    case HTTPoison.get(@radioking_api_uri) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {queue, interval} = parse_streamed_song(body, queue)
        # Reschedule once more
        schedule_work(interval)
        {:noreply, queue}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.debug("Not found :(")
        # Reschedule once more
        schedule_work(60_000)
        {:noreply, queue}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(reason)
        # Reschedule once more
        schedule_work(60_000)
        {:noreply, queue}
    end
  end

  @radioking_api_uri_list "https://www.radioking.com/widgets/api/v1/radio/84322/track/ckoi?limit=10"
  defp list_broadcasted(queue) do
    case HTTPoison.get(@radioking_api_uri_list) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        json = Poison.decode!(body)

        json
        |> Enum.reverse()
        |> Enum.reduce(queue, fn song, queue ->
          song
          |> Map.take(@expected_fields)
          |> filled_from_db()
          |> :queue.in(queue)
        end)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts(reason)
    end
  end

  defp schedule_work(interval) do
    Process.send_after(self(), :work, interval)
  end

  defp parse_streamed_song(body, queue) do
    body
    |> Poison.decode!()
    |> Map.take(@expected_fields)
    |> push_song(queue)
  end

  defp push_song(streamed_song, queue) do
    song = filled_from_db(streamed_song)
    last_queued = :queue.peek_r(queue)

    # song already in queue ?
    queue =
      if same_song?(song, last_queued) do
        queue
      else
        Wsdjs.Jobs.UnmatchSong.notify(song)
        :queue.in(song, queue)
      end

    # no more than 9 elements in queue
    queue =
      if :queue.len(queue) > 9 do
        :queue.drop(queue)
      else
        queue
      end

    # find the new interval adding 1 second to the expected end
    # and then doing an abs() to manage the case where radioking is late
    interval =
      song["end_at"]
      |> Timex.parse!("{ISO:Extended}")
      |> Timex.shift(seconds: 1)
      |> Timex.diff(Timex.now(), :seconds)

    interval =
      if interval <= 0 do
        2
      else
        interval
      end

    PubSub.broadcast(WsdjsWeb.PubSub, "notifications:now_playing", :new_played_song)

    {queue, interval * 1000}
  end

  defp same_song?(_, :empty), do: false

  defp same_song?(a, {:value, b}) do
    if a["title"] == b["title"] && a["artist"] == b["artist"] do
      true
    else
      false
    end
  end

  defp filled_from_db(song) do
    song_in_base = Wsdjs.Musics.get_song_by(song["artist"], song["title"])

    if song_in_base != nil do
      song
      |> Map.put(:suggested_ts, Timex.to_unix(song_in_base.inserted_at))
      |> Map.put(:image_uri, WsdjsWeb.CloudinaryHelper.art_url(song_in_base.art, 900))
      |> Map.put(:image_srcset, WsdjsWeb.CloudinaryHelper.art_srcset(song_in_base.art, 300))
      |> Map.put(:suggested_by, song_in_base.user.name)
      |> Map.put(:suggested_by_path, "/users/#{song_in_base.user.id}")
      |> Map.put(:path, "/songs/#{song_in_base.id}")
      |> Map.put(:tags, tags_for_song(song_in_base))
      |> Map.put(:song_id, song_in_base.id)
    else
      song
      |> Map.put(:nomatch, true)
    end
  end

  defp tags_for_song(song_in_base) do
    with ranks <- Wsdjs.Charts.get_ranks(song_in_base),
         {:ok, rank} <- Enum.fetch(ranks, 0),
         {:ok, _} <- song_position(rank.position) do
      ["Top " <> Timex.format!(rank.top.due_date, "%b%y", :strftime)]
    else
      _ -> []
    end
  end

  defp song_position(pos) when pos <= 10, do: {:ok, pos}
  defp song_position(pos) when pos > 10, do: {:ko, pos}
end
