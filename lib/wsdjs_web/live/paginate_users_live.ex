defmodule WsdjsWeb.PaginateUsersLive do
  use WsdjsWeb, :live_view

  alias Wsdjs.Accounts

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [users: []]}
  end

  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "9")

    paginate_options = %{page: page, per_page: per_page}
    users = Accounts.list_users(paginate: paginate_options)

    socket =
      assign(socket,
        options: paginate_options,
        users: users
      )

    {:noreply, socket}
  end

  defp pagination_link(socket, page, per_page, class, do: content) do
    live_patch(
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          page: page,
          per_page: per_page
        ),
      class: class,
      do: content
    )
  end

  defp pagination_link(socket, text, page, per_page, class) do
    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          page: page,
          per_page: per_page
        ),
      class: class
    )
  end
end
