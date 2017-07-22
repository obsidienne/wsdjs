defmodule Wsdjs.Web.SongController do
  @moduledoc false

  use Wsdjs.Web, :controller

  alias Wsdjs.{Musics, Accounts}
  alias Wsdjs.Musics.{Comment, Song}

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user]]
    apply(__MODULE__, action_name(conn), args)
  end

  def show(conn, %{"id" => id}, current_user) do
    song = Musics.get_song!(current_user, id)
    comments = Musics.list_comments(id)
    comment_changeset = Musics.Comment.changeset(%Comment{})

    render conn, "show.html", song: song, comments: comments, comment_changeset: comment_changeset
  end

  def index(conn, %{"user_id" => user_id, "page" => page}, current_user) do
    page = Musics.paginate_songs_user(current_user, user_id, %{"page" => page})

    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> put_layout(false)
    |> render("index_user_song.html", songs: page.entries)
  end

  def index(conn, %{"page" => page}, current_user) do
    page = Musics.paginate_songs(current_user, %{"page" => page})

    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> put_layout(false)
    |> render("index_hot_song.html", songs: page.entries)
  end

  def index(conn, _params, current_user) do
    page = Musics.paginate_songs(current_user)

    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> render("index.html", songs: page.entries, page_number: page.page_number, total_pages: page.total_pages)
  end

  def new(conn, _params, _current_user) do
    changeset = Musics.change_song(%Song{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"song" => params}, current_user) do
    params = Map.put(params, "user_id", current_user.id)
    case Musics.create_song(current_user, params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, "#{song.title} created")
        |> redirect(to: song_path(conn, :show, song.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    song = Musics.get_song!(current_user, id)
    changeset = Musics.change_song(song)
    render conn, "edit.html", song: song, changeset: changeset
  end

  def update(conn, %{"id" => id, "song" => song_params}, current_user) do
    song = Musics.get_song!(current_user, id)

    if !current_user.admin do
      song_params = Map.drop(song_params, ["user_id", "inserted_at", "title", "artist"])
    end

    case Musics.update_song(song, song_params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, "Song updated")
        |> redirect(to: song_path(conn, :show, song))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", song: song, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    song = Musics.get_song!(current_user, id)
    {:ok, _song} = Musics.delete_song(song)

    conn
    |> put_flash(:info, "Song deleted successfully.")
    |> redirect(to: home_path(conn, :index))
  end
end
