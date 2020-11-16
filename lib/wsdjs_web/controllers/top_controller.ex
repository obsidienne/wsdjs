defmodule WsdjsWeb.TopController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Charts
  alias Wsdjs.Charts.Top

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def show(conn, %{"id" => id}, current_user) do
    top =
      if String.match?(id, ~r/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/) do
        Charts.get_top_by_uuid!(id)
      else
        Charts.get_top!(id)
      end

    with :ok <- Charts.can?(current_user, :show, top) do
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
    with :ok <- Charts.can?(current_user, :create_top) do
      changeset = Charts.change_top_creation(%Top{})
      render(conn, "new.html", changeset: changeset)
    end
  end

  @spec update(Plug.Conn.t(), any(), Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def update(conn, %{"id" => id, "direction" => "next"}, current_user) do
    top = Charts.get_top!(id)

    with :ok <- Charts.can?(current_user, :update_top, top),
         {:ok, _top} = Charts.next_step(top) do
      redirect(conn, to: Routes.top_path(conn, :show, top))
    end
  end

  def update(conn, %{"id" => id, "direction" => "previous"}, current_user) do
    top = Charts.get_top!(id)

    with :ok <- Charts.can?(current_user, :update_top, top),
         {:ok, _top} = Charts.previous_step(top) do
      redirect(conn, to: Routes.top_path(conn, :show, top))
    end
  end

  def create(conn, %{"top" => params}, current_user) do
    params =
      params
      |> Map.put("user_id", current_user.id)
      |> Map.put("due_date", Timex.beginning_of_month(params["due_date"]))

    with :ok <- Charts.can?(current_user, :create_top),
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

    with :ok <- Charts.can?(current_user, :delete_top, top),
         {:ok, _top} = Charts.delete_top(top) do
      conn
      |> put_flash(:info, "Top deleted successfully.")
      |> redirect(to: Routes.live_path(conn, WsdjsWeb.ChartList))
    end
  end
end
