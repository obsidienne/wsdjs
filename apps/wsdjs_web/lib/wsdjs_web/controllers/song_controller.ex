defmodule WsdjsWeb.SongController do
  @moduledoc false

  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  alias Wsdjs.Attachments
  alias Wsdjs.Attachments.Video
  alias Wsdjs.Musics
  alias Wsdjs.Musics.Song
  alias Wsdjs.Playlists
  alias Wsdjs.Reactions
  alias Wsdjs.Reactions.Comment

  action_fallback(WsdjsWeb.FallbackController)

  # def show(%Plug.Conn{assigns: %{layout_type: "mobile"}} = conn, %{"id" => id} = params, current_user) do
  #   show(conn, params, current_user)
  # end

  @spec show(Plug.Conn.t(), %{id: String.t()}, nil | Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def show(conn, %{"id" => id}, current_user) do
    with song <- Musics.get_song!(id),
         :ok <- Musics.Policy.can?(current_user, :show, song) do
      opinions = Reactions.list_opinions(song)
      videos = Attachments.list_videos(song)
      video_changeset = Attachments.change_video(%Video{})
      comment_changeset = Reactions.change_comment(%Comment{})
      ranks = Wsdjs.Charts.get_ranks(song)
      comments = Reactions.list_comments(song)

      render(
        conn,
        "show.html",
        song: song,
        opinions: opinions,
        comments: comments,
        comment_changeset: comment_changeset,
        videos: videos,
        ranks: ranks,
        video_changeset: video_changeset
      )
    end
  end

  def index(conn, params, current_user) do
    interval = Musics.songs_interval(current_user)
    playlists = Playlists.get_playlist_by_user(current_user, current_user)

    month =
      if is_nil(params["month"]) do
        interval[:max]
      else
        params["month"]
        |> Timex.parse!("%Y-%m-%d", :strftime)
        |> Timex.to_date()
        |> Timex.beginning_of_month()
      end

    songs = Musics.list_songs(current_user, month, params["q"])

    conn =
      if Map.get(conn.assigns, :is_ajax) == true do
        put_layout(conn, false)
      else
        conn
      end

    render(
      conn,
      "index#{Map.get(conn.assigns, :ajax_suffix)}.html",
      songs: songs,
      month: month,
      playlists: playlists,
      last: Timex.before?(month, interval[:min])
    )
  end

  @spec new(Plug.Conn.t(), any(), Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
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

  @spec edit(Plug.Conn.t(), %{id: String.t()}, Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def edit(conn, %{"id" => id}, current_user) do
    with %Song{} = song <- Musics.get_song!(id),
         :ok <- Musics.Policy.can?(current_user, :edit_song, song) do
      changeset = Musics.change_song(song)
      render(conn, "edit.html", song: song, changeset: changeset)
    end
  end

  @spec update(Plug.Conn.t(), %{id: String.t(), song: map()}, Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
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

      {:error, :unauthorized} ->
        {:error, :unauthorized}
    end
  end

  @spec delete(Plug.Conn.t(), %{id: String.t()}, Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
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
