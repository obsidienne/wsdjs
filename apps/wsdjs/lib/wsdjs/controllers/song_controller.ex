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
    page = Wcsp.Musics.paginate_songs(current_user)

    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> render "index.html", songs: page.entries, page_number: page.page_number, total_pages: page.total_pages
  end
  @doc """
  No authZ needed, this function does not modify the database
  """
  def new(conn, _params) do
    changeset = Wcsp.Musics.Song.changeset(%Wcsp.Musics.Song{})
    render(conn, "new.html", changeset: changeset)
  end


  def create(conn, %{"song" => params}) do
    current_user = conn.assigns[:current_user]

    case Wcsp.Musics.create_song(current_user, params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, "#{song.title} created")
        |> redirect(to: song_path(conn, :show, song.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
