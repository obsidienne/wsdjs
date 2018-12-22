defmodule WsdjsWeb.SuggestionController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Musics.Songs
  alias Wsdjs.Musics.Song

  action_fallback(WsdjsWeb.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, current_user) do
    with :ok <- Songs.can?(current_user, :suggest) do
      changeset = Songs.change(%Song{})
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"song" => params}, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    with :ok <- Songs.can?(current_user, :suggest),
         {:ok, song} <- Songs.create_suggestion(params) do
      conn
      |> put_flash(:info, "#{song.title} suggested")
      |> redirect(to: Routes.song_path(conn, :show, song.id))
    end
  end
end
