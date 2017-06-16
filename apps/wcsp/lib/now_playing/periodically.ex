defmodule Wcsp.Periodically do
  require Logger
  require DateTime

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

  def handle_call({:read}, _, queue) do
    list = :queue.to_list(queue)
    {:reply, Enum.reverse(list), queue}
  end

  defp metadata(body) do
    text_without_tags = HtmlSanitizeEx.strip_tags(body)
    list = String.split(text_without_tags, "," , parts: 7, trim: true)
    Enum.at(list, 6)    
  end

  @months %{1 => "Jan", 2 => "Feb", 3 => "Mar", 4 => "Apr",
            5 => "May", 6 => "Jun", 7 => "Jul", 8 => "Aug",
            9 => "Sep", 10 => "Oct", 11 => "Nov", 12 => "Dec"}

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
      
      song_in_base = Wcsp.Musics.search_artist_title(new_metadata)      
      if song_in_base != nil do
        song = Map.put(song, :image_uri, Wsdjs.SongHelper.song_art_href(song_in_base.art))
        song = Map.put(song, :suggested_by, song_in_base.user.name)
        song = Map.put(song, :suggested_by_path, "/users/#{song_in_base.user.id}")
        song = Map.put(song, :path, "/songs/#{song_in_base.id}")        
        inserted_ts = elem(DateTime.from_naive(song_in_base.inserted_at, "Etc/UTC"), 1) |> DateTime.to_unix                
        song = Map.put(song, :suggested_ts, inserted_ts)
        tags = []
        if length(song_in_base.tops) > 0 do
          top_head = Enum.at(song_in_base.tops, 0)
          if length(top_head.ranks) > 0 do
            rank_head = Enum.at(top_head.ranks , 0)
                    
            if (rank_head.position < 10) do
              date = top_head.due_date
              top = "Top " <> @months[date.month] <> String.slice(Integer.to_string(date.year), 2..3)
              tags = tags ++ [top]
            end            
          end
        end
        song = Map.put(song, :tags, tags)     
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
    Process.send_after(self(), :work, 5 * 1 * 1 * 1000) # In 5 seconds
  end

end