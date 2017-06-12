defmodule Wsdjs.SongController do
  use Wsdjs, :controller

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    song = Wcsp.Musics.get_song!(current_user, id)
    comments = Wcsp.Musics.list_comments(id)
    comment_changeset = Wcsp.Musics.Comment.changeset(%Wcsp.Musics.Comment{})

    render conn, "show.html", song: song, comments: comments, comment_changeset: comment_changeset
  end

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    songs = Wcsp.Musics.list_songs(current_user)

    render conn, "index.html", songs: songs
  end
end
