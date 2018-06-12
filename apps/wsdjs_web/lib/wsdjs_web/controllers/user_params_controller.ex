defmodule WsdjsWeb.UserParamsController do
  @moduledoc false
  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User

  action_fallback(WsdjsWeb.FallbackController)

  def show(conn, %{"id" => user_id}, current_user) do
    with %User{} = user <- Accounts.get_user!(user_id),
         :ok <- Accounts.Policy.can?(current_user, :show, user) do
      suggested_songs = Wsdjs.Musics.count_suggested_songs(user)
      changeset = Accounts.change_user(user)

      conn
      |> render(
        "show.html",
        user: user,
        changeset: changeset,
        suggested_songs: suggested_songs
      )
    end
  end
end
