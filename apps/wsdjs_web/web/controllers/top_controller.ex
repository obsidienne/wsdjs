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

  def new(conn, _params) do
    changeset = Wcsp.Top.changeset(%Wcsp.Top{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"top" => params}) do
    user = conn.assigns[:current_user]

    conn
    |> put_flash(:error, "not implemented !")
    |> redirect(to: top_path(conn, :index))
  end
end
