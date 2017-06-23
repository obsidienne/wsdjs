defmodule Wsdjs.Web.SongController do
  use Wsdjs.Web, :controller

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    song = Wsdjs.Musics.get_song!(current_user, id)
    comments = Wsdjs.Musics.list_comments(id)
    comment_changeset = Wsdjs.Musics.Comment.changeset(%Wsdjs.Musics.Comment{})

    render conn, "show.html", song: song, comments: comments, comment_changeset: comment_changeset
  end

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    page = Wsdjs.Musics.paginate_songs(current_user)

    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> render("index.html", songs: page.entries, page_number: page.page_number, total_pages: page.total_pages)
  end
  @doc """
  No authZ needed, this function does not modify the database
  """
  def new(conn, _params) do
    changeset = Wsdjs.Musics.Song.changeset(%Wsdjs.Musics.Song{})
    render(conn, "new.html", changeset: changeset)
  end


  def create(conn, %{"song" => params}) do
    current_user = conn.assigns[:current_user]

    case Wsdjs.Musics.create_song(current_user, params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, "#{song.title} created")
        |> redirect(to: song_path(conn, :show, song.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    song = Wsdjs.Musics.get_song!(current_user, id)
    changeset = Wsdjs.Musics.change_song(song)
    render conn, "edit.html", song: song, changeset: changeset
  end

  def update(conn, %{"id" => id, "song" => song_params}) do
    current_user = conn.assigns[:current_user]
    song = Wsdjs.Musics.get_song!(current_user, id)

    case Wsdjs.Musics.update_song(song, song_params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, "Song updated")
        |> redirect(to: song_path(conn, :show, song))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", song: song, changeset: changeset)
    end
  end

end
