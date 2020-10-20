defmodule WsdjsWeb.MusicLibrary do
  use WsdjsWeb, :live_view

  alias WsdjsWeb.MusicComponent

  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket), temporary_assigns: [songs: []]}
  end

  def handle_params(params, _url, socket) do
    current_user = socket.assigns[:current_user]

    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "9")

    sort_by = (params["sort_by"] || "id") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    paginate_options = %{page: page, per_page: per_page}
    sort_options = %{sort_by: sort_by, sort_order: sort_order}

    total_pages = ceil(Wsdjs.Songs.count_songs(current_user) / per_page)

    songs =
      Wsdjs.Songs.list_songs(current_user,
        paginate: paginate_options,
        sort: sort_options
      )

    socket =
      assign(socket,
        options: Map.merge(paginate_options, sort_options),
        total_pages: total_pages,
        songs: songs
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
          per_page: options.per_page,
          sort_by: options.sort_by,
          sort_order: options.sort_order
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
          per_page: options.per_page,
          sort_by: options.sort_by,
          sort_order: options.sort_order
        ),
      class: class
    )
  end

  defp sort_link(socket, text, sort_by, options) do
    text = style_sorting(options.sort_order, text: text)

    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          sort_by: sort_by,
          sort_order: toggle_sort_order(options.sort_order),
          page: options.page,
          per_page: options.per_page
        ),
      class:
        "-ml-px relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm leading-5 font-medium rounded-r-md text-gray-700 bg-gray-50 hover:text-gray-500 hover:bg-white focus:outline-none focus:shadow-outline-blue focus:border-blue-300 active:bg-gray-100 active:text-gray-700 transition ease-in-out duration-150"
    )
  end

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc

  defp style_sorting(:asc, assigns) do
    assigns = Enum.into(assigns, %{})

    ~L"""
    <svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
      <path d="M3 3a1 1 0 000 2h11a1 1 0 100-2H3zM3 7a1 1 0 000 2h7a1 1 0 100-2H3zM3 11a1 1 0 100 2h4a1 1 0 100-2H3zM15 8a1 1 0 10-2 0v5.586l-1.293-1.293a1 1 0 00-1.414 1.414l3 3a1 1 0 001.414 0l3-3a1 1 0 00-1.414-1.414L15 13.586V8z" />
    </svg>
    <span class="ml-2"><%= @text %></span>
    """
  end

  defp style_sorting(:desc, assigns) do
    assigns = Enum.into(assigns, %{})

    ~L"""
    <svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
      <path d="M3 3a1 1 0 000 2h11a1 1 0 100-2H3zM3 7a1 1 0 000 2h5a1 1 0 000-2H3zM3 11a1 1 0 100 2h4a1 1 0 100-2H3zM13 16a1 1 0 102 0v-5.586l1.293 1.293a1 1 0 001.414-1.414l-3-3a1 1 0 00-1.414 0l-3 3a1 1 0 101.414 1.414L13 10.414V16z" />
    </svg>
    <span class="ml-2"><%= @text %></span>
    """
  end
end
