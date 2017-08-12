defmodule WsdjsWeb.TopController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Charts
  alias Wsdjs.Charts.Top

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user]]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, %{"page" => page}, current_user) do
    page = Charts.paginate_tops(current_user, %{"page" => page, "page_size" => 3})
    
    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> put_layout(false)
    |> render("_index_top.html", tops: page.entries)
  end

  def index(conn, _params, current_user) do
    page = Charts.paginate_tops(current_user, %{"page_size" => 3})
    
    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> render("index.html", tops: page.entries, page_number: page.page_number, total_pages: page.total_pages)
  end

  def show(conn, %{"id" => id}, current_user) do
    top = Charts.get_top!(current_user, id)
    changeset = Top.changeset(top)

    case top.status do
      "checking" ->
        render conn, "checking.html", top: top, changeset: changeset
      "voting" ->
        top = Charts.get_top_order_by_votes!(current_user, id)
        votes = Charts.list_votes(top)
        current_user_votes = Charts.list_votes(id, current_user)
        render conn, "voting.html", top: top,
                                    votes: votes,
                                    current_user_votes: current_user_votes,
                                    changeset: changeset
      "counting" ->
        render conn, "counting.html", top: top, changeset: changeset
      "published" ->
        render conn, :published, top: top, changeset: changeset
      _ ->
        raise ArgumentError, "The template requested does not exist. Something smelly."
    end
  end

  def new(conn, _params, _current_user) do
    changeset = Top.changeset(%Top{})
    render(conn, "new.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "direction" => "next"}, current_user) do
    top = Charts.get_top!(current_user, id)
    Charts.next_step(current_user, top)
    top = Charts.get_top!(current_user, id)

    redirect(conn, to: top_path(conn, :show, top))
  end

  def update(conn, %{"id" => id, "direction" => "previous"}, current_user) do
    top = Charts.get_top!(current_user, id)
    Charts.previous_step(current_user, top)
    top = Charts.get_top!(current_user, id)

    redirect(conn, to: top_path(conn, :show, top))
  end

  def create(conn, %{"top" => params}, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    case Charts.create_top(current_user, params) do
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
    top = Charts.get_top!(current_user, id)
    {:ok, _top} = Charts.delete_top(top)

    conn
    |> put_flash(:info, "Top deleted successfully.")
    |> redirect(to: home_path(conn, :index))
  end
end
