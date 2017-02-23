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

    case Wcsp.create_top(user, params) do
      {:ok, top} ->
        conn
        |> put_flash(:info, "Top created !")
        |> redirect(to: top_path(conn, :show, top.id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong !")
        |> render("new.html", changeset: changeset)
    end
  end
end
