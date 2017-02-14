defmodule WsdjsWeb.TopController do
  use WsdjsWeb.Web, :controller

  def index(conn, _params) do
    tops = Wcsp.tops()
    changeset = Wcsp.Top.changeset(%Wcsp.Top{})

    render conn, "index.html", tops: tops, changeset: changeset
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.html", top: Wcsp.top(id)
  end

  def create(conn, %{"top" => top_params}) do


  end
end
