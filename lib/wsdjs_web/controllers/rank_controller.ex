defmodule WsdjsWeb.RankController do
  @moduledoc false
  use WsdjsWeb, :controller
  alias Wsdjs.Charts

  def update(conn, %{"id" => id, "rank" => rank_params}) do
    case Charts.set_bonus(id, rank_params["bonus"]) do
      {:ok, rank} ->
        conn
        |> put_flash(:info, "Bonus set")
        |> redirect(to: Routes.top_path(conn, :show, rank.top_id))

      {:error, _changeset} ->
        rank = Wsdjs.Repo.get!(Charts.Rank, id)

        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: Routes.top_path(conn, :show, rank.top_id))
    end
  end

  def delete(conn, %{"id" => id}) do
    rank = Charts.get_rank!(id)
    {:ok, _rank} = Charts.delete_rank(rank)

    conn
    |> put_flash(:info, "Song removed successfully.")
    |> redirect(to: Routes.top_path(conn, :show, rank.top_id))
  end
end
