defmodule BrididiWeb.ChartList do
  use BrididiWeb, :live_view

  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket), temporary_assigns: [charts: []]}
  end

  def handle_params(params, _url, socket) do
    current_user = socket.assigns[:current_user]

    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "12")
    total_pages = ceil(Brididi.Charts.count_charts(current_user) / per_page)

    paginate_options = %{page: page, per_page: per_page, total_pages: total_pages}
    sort_options = %{sort_by: :due_date, sort_order: :desc}

    tops =
      Brididi.Charts.list_tops(current_user,
        paginate: paginate_options,
        sort: sort_options
      )

    tops = Brididi.Musics.preload_songs(tops)

    socket =
      assign(socket,
        options: paginate_options,
        tops: tops
      )

    {:noreply, socket}
  end

  defp pagination_link(socket, page, options, class, do: content) do
    live_patch(
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          page: page,
          per_page: options.per_page
        ),
      class: class,
      do: content
    )
  end

  defp pagination_link(socket, text, page, options, class) do
    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          page: page,
          per_page: options.per_page
        ),
      class: class
    )
  end
end
