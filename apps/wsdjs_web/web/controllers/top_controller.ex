defmodule WsdjsWeb.TopController do
  use WsdjsWeb.Web, :controller

  def index(conn, _params) do
    tops = Wcsp.tops()
    changeset = Wcsp.Top.changeset(%Wcsp.Top{})

    render conn, "index.html", tops: tops, changeset: changeset
  end

  def show(conn, %{"id" => id}) do
    top = Wcsp.top(id)

    case top.status do
      "creating" -> top_creating(conn, top)
      "voting" -> top_voting(conn, top)
      "counting" -> top_counting(conn, top)
      "published" -> top_published(conn, top)
    end

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

  @doc """
  Only visible by an admin or the top creator
  """
  defp top_creating(conn, top) do
    render conn, "creating.html", top: top
  end

  defp top_voting(conn, top) do
    render conn, "voting.html", top: top
  end

  defp top_counting(conn, top) do
    render conn, "counting.html", top: top
  end

  defp top_published(conn, top) do
    render conn, "published.html", top: top
  end
end
