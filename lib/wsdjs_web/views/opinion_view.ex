defmodule WsdjsWeb.OpinionView do
  use WsdjsWeb, :view

  def count(opinions, kind) when kind in ["up", "down", "like"] do
    Enum.count(opinions, fn x -> x.kind == kind end)
  end

  def options(kind, _conn, _song, _opinions, nil) do
    [class: "border-0 p-2 song-#{kind}"]
  end

  def options(kind, _conn, _song, opinions, current_user) do
    my_opinion = Enum.find(opinions, fn x -> x.user_id == current_user.id end)

    [class: html_class(kind, my_opinion)]
  end

  defp html_class(kind, %Wsdjs.Reactions.Opinions.Opinion{kind: my_kind}) when kind == my_kind,
    do: "border-0 p-2 song-#{kind} active hover:animate__animated hover:animate__swing"

  defp html_class(kind, _),
    do: "border-0 p-2 song-#{kind} hover:animate__animated  hover:animate__swing"
end
