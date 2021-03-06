defmodule WsdjsWeb.SongController do
  @moduledoc false

  use WsdjsWeb, :controller

  alias Wsdjs.Attachments
  alias Wsdjs.Attachments.Videos.Video
  alias Wsdjs.Musics.Song
  alias Wsdjs.Musics.Songs
  alias Wsdjs.Playlists
  alias Wsdjs.Reactions.{Comments, Opinions}

  action_fallback(WsdjsWeb.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  @spec show(Plug.Conn.t(), %{id: String.t()}, nil | Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def show(conn, %{"id" => id}, current_user) do
    song =
      if String.match?(id, ~r/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/) do
        Songs.get_song_by_uuid!(id)
      else
        Songs.get_song!(id)
      end

    with :ok <- Songs.can?(current_user, :show, song) do
      opinions = Opinions.list(song)
      videos = Attachments.list_videos(song)
      video_changeset = Attachments.change_video(%Video{})
      comment_changeset = Comments.change()
      ranks = Wsdjs.Charts.get_ranks(song)
      comments = Comments.list(song)
      playlists = Playlists.get_playlist_by_user(current_user, current_user)

      render(
        conn,
        "show.html",
        song: song,
        opinions: opinions,
        comments: comments,
        playlists: playlists,
        comment_changeset: comment_changeset,
        videos: videos,
        ranks: ranks,
        video_changeset: video_changeset
      )
    end
  end

  def index(conn, _params, current_user) do
    playlists = Playlists.get_playlist_by_user(current_user, current_user)

    render(conn, "index.html", playlists: playlists)
  end

  @spec new(Plug.Conn.t(), any(), Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def new(conn, _params, current_user) do
    with :ok <- Songs.can?(current_user, :create) do
      changeset = Songs.change(%Song{})
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"song" => params}, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    with :ok <- Songs.can?(current_user, :create),
         {:ok, song} <- Songs.create_song(params) do
      conn
      |> put_flash(:info, "#{song.title} created")
      |> redirect(to: Routes.song_path(conn, :show, song.id))
    end
  end

  @spec update(Plug.Conn.t(), %{id: String.t(), song: map()}, Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def update(conn, %{"id" => id, "song" => song_params}, current_user) do
    song = Songs.get_song!(id)

    with :ok <- Songs.can?(current_user, :edit, song),
         {:ok, %Song{} = song} <- Songs.update(song, song_params, current_user) do
      conn
      |> put_flash(:info, "Song updated")
      |> redirect(to: Routes.song_path(conn, :show, song))
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
    song = Songs.get_song!(id)

    with :ok <- Songs.can?(current_user, :delete, song),
         {:ok, _song} = Songs.delete(song) do
      conn
      |> put_flash(:info, "Song deleted successfully.")
      |> redirect(to: Routes.home_path(conn, :index))
    end
  end
end
