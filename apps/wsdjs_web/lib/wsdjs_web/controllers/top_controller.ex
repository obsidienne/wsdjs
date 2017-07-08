defmodule Wsdjs.Web.TopController do
  use Wsdjs.Web, :controller

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    tops = Wsdjs.Trendings.list_tops(current_user)

    render conn, "index.html", tops: tops
  end

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    top = Wsdjs.Trendings.get_top(current_user, id)
    top = Wsdjs.Repo.preload(top, votes: Wsdjs.Trendings.list_votes(top, current_user))
    votes = Wsdjs.Trendings.list_votes(top)
    changeset = Wsdjs.Trendings.Top.changeset(top)

    cond do
      top.status == "checking" ->
        render conn, "checking.html", top: top, votes: votes, changeset: changeset
      top.status == "voting" ->
        render conn, "voting.html", top: top, votes: votes, changeset: changeset
      top.status == "counting" ->
        render conn, "counting.html", top: top, votes: votes, changeset: changeset
      top.status == "published" ->
        render conn, :published, top: top, votes: votes, changeset: changeset
      true -> raise ArgumentError, "The template requested does not exist. Something smelly."
    end
  end

  @doc """
  No authZ needed, this function does not modify the database
  """
  def new(conn, _params) do
    changeset = Wsdjs.Trendings.Top.changeset(%Wsdjs.Trendings.Top{})
    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Update the step of a top. You can't update anything else in this function.
  """
  def update(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    top = Wsdjs.Trendings.get_top(current_user, id)
    Wsdjs.Trendings.next_step(current_user, top)
    top = Wsdjs.Trendings.get_top(current_user, id)

    redirect(conn, to: top_path(conn, :show, top))
  end

  def create(conn, %{"top" => params}) do
    current_user = conn.assigns[:current_user]

    case Wsdjs.Trendings.create_top(current_user, params) do
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
