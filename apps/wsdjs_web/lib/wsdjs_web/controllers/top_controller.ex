defmodule Wsdjs.Web.TopController do
  @moduledoc false
  use Wsdjs.Web, :controller

  alias Wsdjs.Trendings
  alias Wsdjs.Trendings.Top

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user]]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    tops = Trendings.list_tops(current_user)

    render conn, "index.html", tops: tops
  end

  def show(conn, %{"id" => id}, current_user) do
    top = Trendings.get_top!(current_user, id)
    changeset = Top.changeset(top)

    cond do
      top.status == "checking" ->
        render conn, "checking.html", top: top, changeset: changeset
      top.status == "voting" ->
        votes = Trendings.list_votes(top)
        current_user_votes = Trendings.list_votes(id, current_user)
        render conn, "voting.html", top: top, 
                                    votes: votes, 
                                    current_user_votes: current_user_votes,
                                    changeset: changeset
      top.status == "counting" ->
        render conn, "counting.html", top: top, changeset: changeset
      top.status == "published" ->
        render conn, :published, top: top, changeset: changeset
      true -> raise ArgumentError, "The template requested does not exist. Something smelly."
    end
  end

  def new(conn, _params, _current_user) do
    changeset = Top.changeset(%Top{})
    render(conn, "new.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "direction" => "next"}, current_user) do
    top = Trendings.get_top!(current_user, id)
    Trendings.next_step(current_user, top)
    top = Trendings.get_top!(current_user, id)

    redirect(conn, to: top_path(conn, :show, top))
  end

  def update(conn, %{"id" => id, "direction" => "previous"}, current_user) do
    top = Trendings.get_top!(current_user, id)
    Trendings.previous_step(current_user, top)
    top = Trendings.get_top!(current_user, id)

    redirect(conn, to: top_path(conn, :show, top))
  end
  

  def create(conn, %{"top" => params}, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    case Trendings.create_top(current_user, params) do
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
    top = Trendings.get_top!(current_user, id)
    {:ok, _top} = Trendings.delete_top(top)

    conn
    |> put_flash(:info, "Top deleted successfully.")
    |> redirect(to: home_path(conn, :index))
  end
end
