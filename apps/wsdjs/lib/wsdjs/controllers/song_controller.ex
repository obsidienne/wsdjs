defmodule Wsdjs.SongController do
  use Wsdjs, :controller

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    song = Wcsp.Musics.find_song!(current_user, id: id)
    comments = Wcsp.Musics.list_comments(id)
    comment_changeset = Wcsp.Musics.Comment.changeset(%Wcsp.Musics.Comment{})

    render conn, "show.html", song: song, comments: comments, comment_changeset: comment_changeset
  end
end
