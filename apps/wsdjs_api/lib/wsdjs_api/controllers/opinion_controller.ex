defmodule WsdjsApi.Web.OpinionController do
  use WsdjsApi.Web, :controller

  alias Wcsp.Musics
  alias Wcsp.Musics.Opinion

  action_fallback WsdjsApi.Web.FallbackController

  def create(conn, %{"opinion" => opinion_params}) do
    with {:ok, %Opinion{} = opinion} <- Musics.upsert_opinion(opinion_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", opinion_path(conn, :show, opinion))
      |> render("show.json", opinion: opinion)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    opinion = Musics.get_opinion!(id)
    with {:ok, %Opinion{}} <- Musics.delete_opinion(opinion) do
      send_resp(conn, :no_content, "")
    end
  end
end
