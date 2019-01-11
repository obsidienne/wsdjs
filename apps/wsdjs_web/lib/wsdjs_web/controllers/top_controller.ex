defmodule WsdjsWeb.TopController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Charts
  alias Wsdjs.Charts.Top

  action_fallback(WsdjsWeb.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, %{"page" => page}, current_user) do
    page = Charts.paginate_tops(current_user, %{"page" => page, "page_size" => 12})

    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> put_layout(false)
    |> render(
      "_index_top.html",
      tops: page.entries,
      page_number: page.page_number,
      total_pages: page.total_pages
    )
  end

  def index(conn, _params, current_user) do
    page = Charts.paginate_tops(current_user, %{"page_size" => 12})

    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> render(
      "index.html",
      tops: page.entries,
      page_number: page.page_number,
      total_pages: page.total_pages
    )
  end

  def stat(conn, %{"id" => id}, current_user) do
    with :ok <- Charts.Policy.can?(current_user, :stats_top) do
      top = Charts.stat_top!(current_user, id)

      render(conn, :stat, top: top)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    top =
      if String.match?(id, ~r/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/) do
        Charts.get_top_by_uuid!(id)
      else
        Charts.get_top!(id)
      end

    with :ok <- Charts.Policy.can?(current_user, :show, top) do
      render(
        conn,
        :show,
        top: top,
        votes: Charts.list_votes(top, current_user),
        ranks: Charts.list_rank(current_user, top),
        changeset: Charts.change_top_step(top)
      )
    end
  end

  @spec new(Plug.Conn.t(), any(), Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def new(conn, _params, current_user) do
    with :ok <- Charts.Policy.can?(current_user, :create_top) do
      changeset = Charts.change_top_creation(%Top{})
      render(conn, "new.html", changeset: changeset)
    end
  end

  @spec update(Plug.Conn.t(), any(), Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def update(conn, %{"id" => id, "direction" => "next"}, current_user) do
    top = Charts.get_top!(id)

    with :ok <- Charts.Policy.can?(current_user, :update_top, top),
         {:ok, _top} = Charts.next_step(top) do
      redirect(conn, to: Routes.top_path(conn, :show, top))
    end
  end

  def update(conn, %{"id" => id, "direction" => "previous"}, current_user) do
    top = Charts.get_top!(id)

    with :ok <- Charts.Policy.can?(current_user, :update_top, top),
         {:ok, _top} = Charts.previous_step(top) do
      redirect(conn, to: Routes.top_path(conn, :show, top))
    end
  end

  def create(conn, %{"top" => params}, current_user) do
    params =
      params
      |> Map.put("user_id", current_user.id)
      |> Map.put("due_date", Timex.beginning_of_month(params["due_date"]))

    with :ok <- Charts.Policy.can?(current_user, :create_top),
         {:ok, top} <- Charts.create_top(params) do
      conn
      |> put_flash(:info, "Top created !")
      |> redirect(to: Routes.top_path(conn, :show, top.id))
    end
  end

  @spec delete(Plug.Conn.t(), map(), Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def delete(conn, %{"id" => id}, current_user) do
    top = Charts.get_top!(id)

    with :ok <- Charts.Policy.can?(current_user, :delete_top, top),
         {:ok, _top} = Charts.delete_top(top) do
      conn
      |> put_flash(:info, "Top deleted successfully.")
      |> redirect(to: Routes.top_path(conn, :index))
    end
  end
end
