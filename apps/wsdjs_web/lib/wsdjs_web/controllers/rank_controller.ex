defmodule Wsdjs.Web.RankController do
  @moduledoc false
  use Wsdjs.Web, :controller
  alias Wsdjs.Rankings

  def update(conn, %{"id" => id, "rank" => rank_params}) do
    case Rankings.set_bonus(id, rank_params["bonus"]) do
      {:ok, rank} ->
        conn
        |> put_flash(:info, "Bonus set")
        |> redirect(to: top_path(conn, :show, rank.top_id))
      {:error, changeset} ->
        rank = Wsdjs.Repo.get!(Rankings.Rank, id)
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: top_path(conn, :show, rank.top_id))
    end
  end

  def delete(conn, %{"id" => id}) do
    rank = Rankings.get_rank!(id)
    {:ok, _rank} = Rankings.delete_rank(rank)

    conn
    |> put_flash(:info, "Song removed successfully.")
    |> redirect(to: top_path(conn, :show, rank.top_id))
  end
end
