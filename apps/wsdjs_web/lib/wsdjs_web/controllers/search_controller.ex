defmodule Wsdjs.Web.SearchController do
  use Wsdjs.Web, :controller

  plug :put_layout, false

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def index(conn, %{"q" => q}) do
    current_user = conn.assigns[:current_user]
    songs = Wsdjs.Musics.search(current_user, q)

    render conn, "index.html", songs: songs
  end

  def index(conn, %{"type" => "song-list", "page" => page}) do
    current_user = conn.assigns[:current_user]
    page = Wsdjs.Musics.paginate_songs(current_user, %{"page" => page})

    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> render("index_hot_song.html", songs: page.entries)
  end
end
