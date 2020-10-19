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

    paginate_options = %{page: page, per_page: per_page}
    songs = Wsdjs.Songs.list_songs(current_user, paginate: paginate_options)

    socket =
      assign(socket,
        options: paginate_options,
        songs: songs
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
