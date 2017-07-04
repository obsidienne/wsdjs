defmodule Wsdjs.Web.TopTextController do
  use Wsdjs.Web, :controller

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def index(conn, %{"top_id" => id}) do
    current_user = conn.assigns[:current_user]

    top = Wsdjs.Trendings.get_top(current_user, id)

    ranks = Enum.take(top.ranks, 20)
    response = Enum.map(ranks, fn (rank) ->
      song = rank.song      
      points = rank.likes + rank.bonus + rank.votes            
      ["#{rank.position}. ", song.artist, " ", song.title, " (", song.genre, ") - ", Integer.to_string(points) ," pts suggested by ", song.user.name, " on DATE\n"]
    end)

    text conn, response
  end

end