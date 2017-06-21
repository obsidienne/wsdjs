defmodule Wsdjs.NowPlaying do
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

  defp metadata(body) do
    text_without_tags = HtmlSanitizeEx.strip_tags(body)
    list = String.split(text_without_tags, "," , parts: 7, trim: true)
    Enum.at(list, 6)
  end

  defp push_song(seven_response_html, queue) do
    artist = ""
    title = ""
    if (:queue.len(queue) > 0) do
      last_song_in_queue = :queue.get_r(queue)
      artist = last_song_in_queue[:artist]
      title = last_song_in_queue[:title]
    end

    current_metadata = "#{artist} - #{title}"
    new_metadata = metadata(seven_response_html)
    if current_metadata != new_metadata do
      [artist, title] = String.split(new_metadata, " - ", parts: 2, trim: true)

      song = %{
        artist: artist,
        title: title,
        ts: :os.system_time(:seconds)
      }

      song_in_base = Wsdjs.Musics.search_artist_title(new_metadata)
      if song_in_base != nil do
        song = Map.put(song, :image_uri, Wsdjs.Web.SongHelper.song_art_href(song_in_base.art))
        song = Map.put(song, :suggested_by, song_in_base.user.name)
        song = Map.put(song, :suggested_by_path, "/users/#{song_in_base.user.id}")
        song = Map.put(song, :path, "/songs/#{song_in_base.id}")
        song = Map.put(song, :suggested_ts, Timex.to_unix(song_in_base.inserted_at))
        tags = []
        if length(song_in_base.tops) > 0 do
          top_head = Enum.at(song_in_base.tops, 0)
          if length(top_head.ranks) > 0 do
            rank_head = Enum.at(top_head.ranks , 0)

            if (rank_head.position < 10) do
              top = "Top " <> Timex.format!(top_head.due_date, "%b%y", :strftime)
              tags = tags ++ [top]
            end
          end
        end
        song = Map.put(song, :tags, tags)
        PubSub.broadcast Wsdjs.Web.PubSub, "notifications:now_playing", :new_played_song
      end

      if (:queue.len(queue) > 9) do
        queue = :queue.drop(queue)
      end
      queue = :queue.in(song, queue)

      IO.inspect song
    end

    queue
  end

  @seven_url "http://37.58.75.166:8384/7.html"
  def handle_info(:work, queue) do
    case HTTPoison.get(@seven_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        queue = push_song(body, queue)
        schedule_work() # Reschedule once more
        {:noreply, queue}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.debug "Not found :("
        {:noreply, queue}
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        {:noreply, queue}
    end
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 2 * 1 * 1 * 1000) # In 2 seconds
  end

end
