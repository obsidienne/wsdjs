defmodule Wsdjs.TopController do
  use Wsdjs, :controller

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    tops = Wcsp.Trendings.list_tops(current_user)

    render conn, "index.html", tops: tops
  end

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    top = Wcsp.Trendings.get_top(current_user, id)
    top = Wcsp.Repo.preload(top, votes: Wcsp.Trendings.Vote.for_user_and_top(top, current_user))
    changeset = Wcsp.Trendings.Top.changeset(top)

    render conn, "#{top.status}.html", top: top, changeset: changeset
  end

  @doc """
  No authZ needed, this function does not modify the database
  """
  def new(conn, _params) do
    changeset = Wcsp.Trendings.Top.changeset(%Wcsp.Trendings.Top{})
    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Update the step of a top. You can't update anything else in this function.
  """
  def update(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    top = Wcsp.Trendings.get_top(current_user, id)
    Wcsp.Trendings.next_step(current_user, top)
    top = Wcsp.Trendings.get_top(current_user, id)

    redirect(conn, to: top_path(conn, :show, top))
  end

  def create(conn, %{"top" => params}) do
    current_user = conn.assigns[:current_user]

    case Wcsp.Trendings.create_top(current_user, params) do
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
