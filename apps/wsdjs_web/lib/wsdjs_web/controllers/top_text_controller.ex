defmodule Wsdjs.Web.TopTextController do
  use Wsdjs.Web, :controller
  
  require Timex
  require Date

  def index(conn, %{"top_id" => id}) do
    current_user = conn.assigns[:current_user]

    top = Wsdjs.Trendings.get_top(current_user, id)

    ranks = Enum.take(top.ranks, 20)
    response = Enum.map(ranks, fn (rank) ->
      song = rank.song      
      points = rank.likes + rank.bonus + rank.votes       
      datetime = song.inserted_at
      year = String.slice(Integer.to_string(datetime.year), 2..4)
      date = Timex.month_shortname(datetime.month) <> " " <> year
      ["#{rank.position}. ", song.artist, " ", song.title, " (", song.genre, ") - ", Integer.to_string(points) ," pts suggested by ", song.user.name, " on ", date, "\n"]
    end)

    text conn, response    
  end

end