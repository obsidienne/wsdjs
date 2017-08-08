defmodule WsdjsWeb.Api.V1.OpinionView do
  use WsdjsWeb, :view

  alias WsdjsWeb.Api.V1.OpinionView

  def render("index.json", %{song: song, opinions: opinions, current_user: current_user}) do
    current_opinion = Enum.find(opinions, nil, fn(x) -> x.user_id == current_user.id end)

    ups = Enum.filter(opinions, fn(x) -> x.kind == "up" end)
    likes = Enum.filter(opinions, fn(x) -> x.kind == "like" end)
    downs = Enum.filter(opinions, fn(x) -> x.kind == "down" end)

    user_opinion = if current_opinion do
      current_opinion.kind
    else
      nil
    end

    %{
      data: %{
        user_opinion: user_opinion,
        song_id: song.id,
        up: render_opinion(ups, "up", song, current_opinion),
        like: render_opinion(likes, "like", song, current_opinion),
        down: render_opinion(downs, "down", song, current_opinion)
      }
    }
  end

  def render("opinion.json", %{opinion: opinion}) do
    %{
      name: user_displayed_name(opinion.user),
      url: user_path(WsdjsWeb.Endpoint, :show, opinion.user),
      avatar: avatar_url(opinion.user.avatar)
    }
  end

  defp render_opinion(opinions, kind, song, nil) do
    %{
      count: Enum.count(opinions),
      users: render_many(opinions, OpinionView, "opinion.json"),
      method: "POST",
      url: api_song_opinion_path(WsdjsWeb.Endpoint, :create, song, kind: kind)
    }
  end

  defp render_opinion(opinions, kind, song, %Wsdjs.Musics.Opinion{} = current) do
    url = if current.kind == kind do
      api_opinion_path(WsdjsWeb.Endpoint, :delete, current.id)
    else
      api_song_opinion_path(WsdjsWeb.Endpoint, :create, song, kind: kind)
    end

    method = if current.kind == kind do "DELETE" else "POST" end

    %{
      count: Enum.count(opinions),
      users: render_many(opinions, OpinionView, "opinion.json"),
      url: url,
      method: method
    }
  end
end
