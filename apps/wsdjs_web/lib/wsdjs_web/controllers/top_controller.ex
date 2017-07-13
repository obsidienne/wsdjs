defmodule Wsdjs.Web.TopController do
  @moduledoc false
  use Wsdjs.Web, :controller

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user]]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    tops = Wsdjs.Trendings.list_tops(current_user)

    render conn, "index.html", tops: tops
  end

  def show(conn, %{"id" => id}, current_user) do
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

  def new(conn, _params, _current_user) do
    changeset = Wsdjs.Trendings.Top.changeset(%Wsdjs.Trendings.Top{})
    render(conn, "new.html", changeset: changeset)
  end

  def update(conn, %{"id" => id}, current_user) do
    top = Wsdjs.Trendings.get_top(current_user, id)
    Wsdjs.Trendings.next_step(current_user, top)
    top = Wsdjs.Trendings.get_top(current_user, id)

    redirect(conn, to: top_path(conn, :show, top))
  end

  def create(conn, %{"top" => params}, current_user) do
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

  def delete(conn, %{"id" => id}, current_user) do
    top = Wsdjs.Trendings.get_top(current_user, id)
    {:ok, _top} = Wsdjs.Trendings.delete_top(top)

    conn
    |> put_flash(:info, "Top deleted successfully.")
    |> redirect(to: home_path(conn, :index))
  end
end
