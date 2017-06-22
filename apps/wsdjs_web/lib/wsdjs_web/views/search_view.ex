defmodule Wsdjs.Web.SearchView do
  use Wsdjs.Web, :view

  def proposed_date(dt), do: Ecto.DateTime.to_iso8601(Ecto.DateTime.cast!(dt))


  def proposed_by_link(conn, %Wsdjs.Musics.Song{} = song) do
    Phoenix.HTML.Link.link(proposed_by_display_name(song.user),
                           to: user_path(conn, :show, song.user.id),
                           title: "#{song.user.name}")
  end


  def comment_class(song) do
    case Enum.count(song.comments) do
      0 -> "song-comment-empty"
      _ -> "song-comment"
    end
  end
end
