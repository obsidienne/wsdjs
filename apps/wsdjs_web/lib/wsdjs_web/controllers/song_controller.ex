defmodule WsdjsWeb.SongController do
  @moduledoc false

  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  alias Wsdjs.Musics
  alias Wsdjs.Reactions
  alias Wsdjs.Reactions.Comment
  alias Wsdjs.Musics.Song
  alias Wsdjs.Attachments
  alias Wsdjs.Attachments.Video

  action_fallback WsdjsWeb.FallbackController

  def show(%Plug.Conn{assigns: %{layout_type: "mobile"}} = conn, %{"id" => id} = params, current_user) do
    show(conn, params, current_user)
  end

  def show(conn, %{"id" => id}, current_user) do
    with song <- Musics.get_song!(id),
         :ok <- Musics.Policy.can?(current_user, :show, song) do

      comments = Reactions.list_comments(song)
      opinions = Reactions.list_opinions(song)
      videos = Attachments.list_videos(song)
      video_changeset = Attachments.change_video(%Video{})
      comment_changeset = Reactions.change_comment(%Comment{})

      render conn, "show.html", song: song,
                                comments: comments,
                                opinions: opinions,
                                comment_changeset: comment_changeset,
                                videos: videos,
                                video_changeset: video_changeset
    end
  end

  def index(conn, %{"user_id" => user_id, "page" => page}, current_user) do
    page = Musics.paginate_songs_user(current_user, user_id, %{"page" => page})

    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> put_layout(false)
    |> render("index_user_song.html", songs: page.entries)
  end

  def index(conn, %{"month" => month}, current_user) do
    month = Timex.beginning_of_month(Timex.to_date(Timex.parse!(month, "%Y-%m-%d", :strftime)))
    songs = Musics.list_songs(current_user, :month, month)
    interval = Musics.songs_interval(current_user)

    conn
    |> put_layout(false)
    |> render("index_hot_song.html", songs: songs, month: month, last: Timex.before?(month, interval[:min]))
  end

  def index(conn, _params, current_user) do
    month_interval = Musics.songs_interval(current_user)
    songs = Musics.list_songs(current_user, :month, month_interval[:max])
    interval = Musics.songs_interval(current_user)

    render(conn, "index.html", songs: songs, month: month_interval[:max], last: Timex.before?(month_interval[:max], interval[:min]))
  end

  def new(conn, _params, current_user) do
    with :ok <- Wsdjs.Musics.Policy.can?(current_user, :create_song) do
      changeset = Musics.change_song(%Song{})
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"song" => params}, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    with :ok <- Wsdjs.Musics.Policy.can?(current_user, :create_song),
         {:ok, song} <- Musics.create_song(params) do
      conn
      |> put_flash(:info, "#{song.title} created")
      |> redirect(to: song_path(conn, :show, song.id))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    with %Song{} = song <- Musics.get_song!(id),
         :ok <- Musics.Policy.can?(current_user, :edit_song, song) do

      changeset = Musics.change_song(song)
      render conn, "edit.html", song: song, changeset: changeset
    end
  end

  def update(conn, %{"id" => id, "song" => song_params}, current_user) do
    song = Musics.get_song!(id)

    with :ok <- Musics.Policy.can?(current_user, :edit_song, song),
         {:ok, %Song{} = song} <- Musics.update_song(song, song_params, current_user) do
  
      conn
      |> put_flash(:info, "Song updated")
      |> redirect(to: song_path(conn, :show, song))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", song: song, user: current_user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    with song <- Musics.get_song!(id),
         :ok <- Musics.Policy.can?(current_user, :delete_song, song),
         {:ok, _song} = Musics.delete_song(song) do

      conn
      |> put_flash(:info, "Song deleted successfully.")
      |> redirect(to: home_path(conn, :index))
    end
  end
end
