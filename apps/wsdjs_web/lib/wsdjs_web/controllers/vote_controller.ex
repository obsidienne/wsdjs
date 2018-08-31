defmodule WsdjsWeb.VoteController do
  @moduledoc false
  use WsdjsWeb, :controller

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"votes" => _votes_params, "top_id" => top_id} = params) do
    current_user = conn.assigns.current_user

    case Wsdjs.Charts.vote(current_user, params) do
      {:ok, _top} ->
        conn
        |> put_flash(:info, "Voted !")
        |> redirect(to: top_path(conn, :show, top_id))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong !")
        |> redirect(to: top_path(conn, :show, top_id))
    end
  end
end
