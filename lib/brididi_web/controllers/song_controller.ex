defmodule BrididiWeb.SongController do
  @moduledoc false

  use BrididiWeb, :controller

  alias Brididi.Attachments
  alias Brididi.Attachments.Video
  alias Brididi.Musics.Song
  alias Brididi.Musics
  alias Brididi.Reactions.{Comments, Opinions}

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, current_user) do
    with :ok <- Musics.can?(current_user, :create) do
      changeset = Musics.change(%Song{})
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"song" => params}, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    with :ok <- Musics.can?(current_user, :create),
         {:ok, song} <- Musics.create_song(params) do
      conn
      |> put_flash(:info, "#{song.title} created")
      |> redirect(to: Routes.song_path(conn, :show, song.id))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => song_id}, current_user) do
    song = Musics.get_song!(song_id)

    with :ok <- Musics.can?(current_user, :edit, song) do
      changeset = Musics.change(song)

      render(
        conn,
        "edit.html",
        song: song,
        changeset: changeset
      )
    end
  end

  @spec update(Plug.Conn.t(), %{id: String.t(), song: map()}, Brididi.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def update(conn, %{"id" => id, "song" => song_params}, current_user) do
    song = Musics.get_song!(id)

    with :ok <- Musics.can?(current_user, :edit, song),
         {:ok, %Song{} = song} <- Musics.update(song, song_params) do
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

  @spec delete(Plug.Conn.t(), %{id: String.t()}, Brididi.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def delete(conn, %{"id" => id}, current_user) do
    song = Musics.get_song!(id)

    with :ok <- Musics.can?(current_user, :delete, song),
         {:ok, _song} = Musics.delete(song) do
      conn
      |> put_flash(:info, "Song deleted successfully.")
      |> redirect(to: Routes.home_path(conn, :index))
    end
  end
end
