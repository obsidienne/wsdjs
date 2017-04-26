defmodule WsdjsApi.Web.RankController do
  @moduledoc """
  This module aims to manage rank API
  """
  use WsdjsApi.Web, :controller

  alias Wcsp.Trendings
  alias Wcsp.Trendings.Rank

  action_fallback WsdjsApi.Web.FallbackController

  def create(conn, %{"rank" => rank_params}) do
    with {:ok, %Rank{} = rank} <- Trendings.create_rank(rank_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", rank_path(conn, :show, rank))
      |> render("show.json", rank: rank)
    end
  end

  def update(conn, %{"id" => id, "rank" => rank_params}) do
    rank = Trendings.get_rank!(id)

    with {:ok, %Rank{} = rank} <- Trendings.update_rank(rank, rank_params) do
      render(conn, "show.json", rank: rank)
    end
  end

  def delete(conn, %{"id" => id}) do
    rank = Trendings.get_rank!(id)
    with {:ok, %Rank{}} <- Trendings.delete_rank(rank) do
      send_resp(conn, :no_content, "")
    end
  end
end
