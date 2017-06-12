defmodule Wcsp.Periodically do
  require Logger
  
  use GenServer
  use HTTPoison.Base

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    q0 = :queue.new()
    is_empty = :queue.is_empty q0
    Logger.debug "1 - q0 : #{is_empty}"
    :queue.in(1, q0)
    is_empty = :queue.is_empty q0
    Logger.debug "2 - q0 : #{is_empty}"
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def metadata(body) do
    text_without_tags = HtmlSanitizeEx.strip_tags(body)
    list = String.split(text_without_tags, ",")    
    items_from_7_index = 7 - length(list) - 1
    items_from_7 = Enum.take(list, items_from_7_index)
    Enum.join(items_from_7, "")
  end

  def update_database(new_metadata) do
    Logger.debug "Update database"
    Logger.debug "new_metadata: #{new_metadata}"
    list = String.split(new_metadata, " - ")    
    artist = Enum.at(list, 0)
    title = Enum.at(list, 1)
    Logger.debug "artist: #{artist} - title: #{title}"
    #song = Wcsp.Repo.get_by(Wcsp.Musics.Song, artist: artist, title: title)
    song = Wcsp.Musics.Song.search_artist_title("MAROON 5", "Don't Want To Know")
    if song != nil do
      Logger.debug "from dj: #{song.user.name}"
    end
  end

  # http://37.58.75.166:8384/7.html
  def handle_info(:work, state) do
    # Do the work you desire here
    current_metadata = state[:current_metadata]
    case HTTPoison.get("http://37.58.75.166:8384/7.html") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->               
        new_metadata = metadata(body)
        if current_metadata != new_metadata do        
          update_database(new_metadata)
          state = %{current_metadata: new_metadata}
        else
          Logger.debug "No need update"
        end 
        schedule_work() # Reschedule once more      
        {:noreply, state}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.debug "Not found :("
        {:noreply, state}
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        {:noreply, state}
    end       
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 5 * 1 * 1 * 1000) # In 5 seconds
  end
end