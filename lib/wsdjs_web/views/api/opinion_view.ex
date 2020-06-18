defmodule WsdjsWeb.Api.OpinionView do
  use WsdjsWeb, :view

  alias WsdjsWeb.Api.OpinionView

  def render("index.json", %{song: song, opinions: opinions, current_user: nil}) do
    ups = Enum.filter(opinions, fn x -> x.kind == "up" end)
    likes = Enum.filter(opinions, fn x -> x.kind == "like" end)
    downs = Enum.filter(opinions, fn x -> x.kind == "down" end)

    %{
      data: %{
        song_id: song.id,
        up: render_opinion(ups, "up", song, nil),
        like: render_opinion(likes, "like", song, nil),
        down: render_opinion(downs, "down", song, nil)
      }
    }
  end

  def render("index.json", %{song: song, opinions: opinions, current_user: current_user}) do
    current_opinion = Enum.find(opinions, nil, fn x -> x.user_id == current_user.id end)

    ups = Enum.filter(opinions, fn x -> x.kind == "up" end)
    likes = Enum.filter(opinions, fn x -> x.kind == "like" end)
    downs = Enum.filter(opinions, fn x -> x.kind == "down" end)

    user_opinion_kind =
      if current_opinion do
        current_opinion.kind
      else
        nil
      end

    user_opinion_id =
      if current_opinion do
        current_opinion.id
      else
        nil
      end

    %{
      data: %{
        user_opinion: user_opinion_kind,
        user_opinion_id: user_opinion_id,
        song_id: song.id,
        up: render_opinion(ups, "up", song, current_opinion),
        like: render_opinion(likes, "like", song, current_opinion),
        down: render_opinion(downs, "down", song, current_opinion)
      }
    }
  end

  def render("opinion.json", %{opinion: opinion}) do
    %{
      name: user_displayed_name_2(opinion.user),
      url: Routes.user_path(WsdjsWeb.Endpoint, :show, opinion.user),
      avatar: Attachments.avatar_url(opinion.user.avatar, 50)
    }
  end

  # if the kind in current_user opinion equals the kind retrieved
  defp render_opinion(
         opinions,
         kind,
         _song,
         %Wsdjs.Reactions.Opinions.Opinion{kind: kind} = current
       ) do
    %{
      count: Enum.count(opinions),
      users: render_many(opinions, OpinionView, "opinion.json"),
      method: "DELETE",
      url: Routes.api_opinion_path(WsdjsWeb.Endpoint, :delete, current),
      tooltip_html: tooltip_from_users(opinions)
    }
  end

  defp render_opinion(opinions, kind, song, _current) do
    %{
      count: Enum.count(opinions),
      users: render_many(opinions, OpinionView, "opinion.json"),
      method: "POST",
      url: Routes.api_song_opinion_path(WsdjsWeb.Endpoint, :create, song.id, kind: kind),
      tooltip_html: tooltip_from_users(opinions)
    }
  end

  defp tooltip_from_users(opinions) do
    names = Enum.map_join(Enum.take(opinions, 3), "<br/>", & &1.user.name)
    remaining_qty = Enum.count(opinions) - 3

    if remaining_qty > 0 do
      names <> "<br/> +#{remaining_qty} dj"
    else
      names
    end
  end

  defp user_displayed_name_2(%{djname: djname}) when is_binary(djname), do: "#{djname}"
  defp user_displayed_name_2(%{name: name}) when is_binary(name), do: name
  defp user_displayed_name_2(%{email: email}), do: email
end
