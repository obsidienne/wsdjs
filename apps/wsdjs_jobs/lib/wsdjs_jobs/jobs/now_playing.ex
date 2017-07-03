defmodule Wsdjs.Jobs.NowPlaying do
  require Logger
  require DateTime

  use GenServer
  use Timex
  use HTTPoison.Base

  alias Phoenix.PubSub

  def start_link(name \\ nil) do
    queue = :queue.new()
    GenServer.start_link(__MODULE__, queue, [name: name])
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def read(pid) do
    GenServer.call(pid, {:read})
  end

  def handle_call({:read}, _, queue) do
    list = :queue.to_list(queue)
    {:reply, Enum.reverse(list), queue}
  end

  @seven_url "http://37.58.75.166:8384/7.html"
  def handle_info(:work, queue) do
    case HTTPoison.get(@seven_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        queue = parse_streamed_song(body, queue)
        schedule_work() # Reschedule once more
        {:noreply, queue}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.debug "Not found :("
        {:noreply, queue}
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error reason
        {:noreply, queue}
    end
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 2 * 1 * 1 * 1000) # In 2 seconds
  end

  defp parse_streamed_song(body, queue) do
    last_queued = last_song_queued(:queue.peek_r(queue))

    body
    |> HtmlSanitizeEx.strip_tags()
    |> String.split("," , parts: 7, trim: true)
    |> Enum.at(6)
    |> push_song(last_queued, queue)
  end

  defp last_song_queued(:empty), do: ""
  defp last_song_queued({:value, song}), do: "#{song[:artist]} - #{song[:title]}"

  defp push_song(song, song, queue), do: queue
  defp push_song(streamed_song, _last_song, queue) do
    [artist, title] = String.split(streamed_song, " - ", parts: 2, trim: true)

    queue = %{artist: artist, title: title, ts: :os.system_time(:seconds)}
            |> filled_from_db(streamed_song)
            |> :queue.in(queue)

    PubSub.broadcast Wsdjs.Web.PubSub, "notifications:now_playing", :new_played_song

    if :queue.len(queue) > 9 do
      :queue.drop(queue)
    else
      queue
    end
  end

  defp filled_from_db(song, streamed_song) do
    song_in_base = Wsdjs.Musics.search_artist_title(streamed_song)

    if song_in_base != nil do
      song
      |> Map.put(:artist, song_in_base.artist)
      |> Map.put(:title, song_in_base.title)
      |> Map.put(:image_uri, Wsdjs.Web.SongHelper.song_art_href(song_in_base.art))
      |> Map.put(:suggested_by, song_in_base.user.name)
      |> Map.put(:suggested_by_path, "/users/#{song_in_base.user.id}")
      |> Map.put(:path, "/songs/#{song_in_base.id}")
      |> Map.put(:suggested_ts, Timex.to_unix(song_in_base.inserted_at))
      |> Map.put(:tags, tags_for_song(song_in_base))
    else
      song
    end
  end

  defp tags_for_song(song_in_base) do
    with {:ok, top_head} <- Enum.fetch(song_in_base.tops, 0),
         {:ok, rank_head} <- Enum.fetch(top_head.ranks, 0),
         {:ok, _} <- song_position(rank_head.position)
    do
      ["Top " <> Timex.format!(top_head.due_date, "%b%y", :strftime)]
    else
      :error -> []
    end
  end

  defp song_position(pos) when pos <= 10, do: {:ok, pos}
  defp song_position(pos) when pos > 10, do: {:ko, pos}
end
