defmodule WcsWeb.PageController do
  use WcsWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
