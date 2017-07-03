defmodule Wsdjs.Web.TopTextController do
  use Wsdjs.Web, :controller

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def index(conn, %{"top_id" => id}) do
    current_user = conn.assigns[:current_user]

    top = Wsdjs.Trendings.get_top(current_user, id)
    top = Wsdjs.Repo.preload(top, :songs)
    IO.inspect top.songs
    text conn, "Showing id #{id}"
  end

end