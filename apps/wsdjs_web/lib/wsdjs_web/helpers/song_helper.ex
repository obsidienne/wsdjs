defmodule Wsdjs.Web.SongHelper do
  @moduledoc """
  This modules contains all helpers for a %Song{}. 
  """
  alias Wsdjs.Musics.Song

  def song_art_alt(%Song{artist: artist, title: title}), do: "#{artist} - #{title} song art"

  def url_for_provider(%Song{video_id: id}) when is_binary(id), do: "http://youtu.be/#{id}"
  def url_for_provider(%Song{url: url}) when is_binary(url), do: url  
  def url_for_provider(_), do: "#"

  def comment_class(song) do
    case Enum.count(song.comments) do
      0 -> "song-comment-empty"
      _ -> "song-comment"
    end
  end

  def suggested_at(dt), do: Ecto.DateTime.to_iso8601(Ecto.DateTime.cast!(dt))
end
 