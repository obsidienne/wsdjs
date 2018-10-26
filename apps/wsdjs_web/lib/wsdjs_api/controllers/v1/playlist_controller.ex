defmodule WsdjsApi.V1.PlaylistController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Playlists

  action_fallback(WsdjsApi.V1.FallbackController)

  @spec index(Plug.Conn.t(), %{id: String.t()}) :: Plug.Conn.t()
  def index(conn, %{"user_id" => user_id}) do
    current_user = conn.assigns[:current_user]

    with user <- Accounts.get_user!(user_id) do
      playlists = Playlists.get_playlist_by_user(user, current_user)

      render(conn, "index.json", playlists: playlists)
    end
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"playlist" => playlist_params, "user_id" => user_id}) do
    current_user = conn.assigns[:current_user]

    playlist_params = Map.put(playlist_params, "user_id", user_id)

    with :ok <- Playlists.Policy.can?(current_user, :new),
         {:ok, playlist} <- Playlists.create_playlist(playlist_params) do
      conn
      |> put_status(:created)
      |> render("show.json", playlist: playlist)
    end
  end
end
