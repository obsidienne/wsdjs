defmodule Wcsp.Periodically do
  require Logger
  
  use GenServer
  use HTTPoison.Base

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

  def handle_call({:read}, from, queue) do
    list = ["milk", "break", "cheese"]
    list = :queue.to_list(queue)
    {:reply, Enum.reverse(list), queue}
  end

  defp metadata(body) do
    text_without_tags = HtmlSanitizeEx.strip_tags(body)
    list = String.split(text_without_tags, ",")    
    items_from_7_index = 7 - length(list) - 1
    items_from_7 = Enum.take(list, items_from_7_index)
    Enum.join(items_from_7, "")   
  end

  defp update_database(new_metadata, queue) do
    Logger.debug "Update database"
    Logger.debug "new_metadata: #{new_metadata}"
    list = String.split(new_metadata, " - ")    
    artist = Enum.at(list, 0)
    title = Enum.at(list, 1)
    Logger.debug "artist: #{artist} - title: #{title}"
    #song_in_base = Wcsp.Repo.get_by(Wcsp.Musics.Song, artist: artist, title: title)
    song_in_base = Wcsp.Musics.Song.search_artist_title("MAROON 5", "Don't Want To Know")
    if song_in_base != nil do
      Logger.debug "from dj: #{song_in_base.user.name}"
      song = %{artist: artist, title: title, suggested_by: song_in_base.user.name, ts: :os.system_time(:seconds)}
      if (:queue.len(queue) > 9) do
        queue = :queue.drop(queue)
      end
      queue = :queue.in(song, queue)
      Logger.debug "queue size : #{:queue.len queue}"   
    end

    queue
  end

  # http://37.58.75.166:8384/7.html
  def handle_info(:work, queue) do
    # Do the work you desire here
    artist = ""
    title = ""
    if (:queue.len(queue) > 0) do
      last_song_in_queue = :queue.get_r(queue)      
      artist = last_song_in_queue[:artist]
      title = last_song_in_queue[:title]      
    end

    current_metadata = "#{artist} - #{title}"     
    
    case HTTPoison.get("http://37.58.75.166:8384/7.html") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->               
        new_metadata = metadata(body)
        if current_metadata != new_metadata do        
          queue = update_database(new_metadata, queue)                    
        else
          Logger.debug "No need update for : #{current_metadata}"
        end 
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
    Process.send_after(self(), :work, 5 * 1 * 1 * 1000) # In 5 seconds
  end

  def initial_queue do    
    :queue.new()
  end
  
end