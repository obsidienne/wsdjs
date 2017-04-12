defmodule Wsdjs.VoteController do
  use Wsdjs, :controller

  def create(conn, %{"votes" => votes_params, "top_id" => top_id} = params) do
    current_user = conn.assigns[:current_user]

    case Wcsp.Trendings.vote(current_user, params) do
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
