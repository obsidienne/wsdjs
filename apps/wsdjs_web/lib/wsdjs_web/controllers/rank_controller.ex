defmodule Wsdjs.Web.RankController do
  use Wsdjs.Web, :controller

  @doc """
  AuthZ needed, data is scoped by current_user
  """
  def update(conn, %{"id" => id, "rank" => rank_params}) do
    case Wsdjs.Trendings.set_bonus(id, rank_params["bonus"]) do
      {:ok, rank} ->
        conn
        |> put_flash(:info, "Bonus set")
        |> redirect(to: top_path(conn, :show, rank.top_id))
      {:error, changeset} ->
        rank = Wsdjs.Repo.get!(Wsdjs.Trendings.Rank, id)
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: top_path(conn, :show, rank.top_id))
    end
  end
end
