defmodule WsdjsWeb.Api.PlaylistController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Playlists

  action_fallback(WsdjsWeb.Api.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  @spec index(Plug.Conn.t(), %{id: String.t()}, Wsdjs.Accounts.User.t() | nil) :: Plug.Conn.t()
  def index(conn, %{"user_id" => user_id}, current_user) do
    with user <- Accounts.get_user!(user_id) do
      playlists = Playlists.get_playlist_by_user(user, current_user)

      render(conn, "index.json", playlists: playlists)
    end
  end

  @spec create(Plug.Conn.t(), map(), Wsdjs.Accounts.User.t() | nil) :: Plug.Conn.t()
  def create(conn, %{"playlist" => playlist_params, "user_id" => user_id}, current_user) do
    playlist_params = Map.put(playlist_params, "user_id", user_id)

    with :ok <- Playlists.can?(current_user, :new),
         {:ok, playlist} <- Playlists.create_playlist(playlist_params) do
      conn
      |> put_status(:created)
      |> render("show.json", playlist: playlist)
    end
  end
end
