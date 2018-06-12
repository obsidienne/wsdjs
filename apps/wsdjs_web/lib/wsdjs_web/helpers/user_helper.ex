defmodule WsdjsWeb.UserHelper do
  @moduledoc """
  This modules contains all helpers for a %User{}.
  """
  import WsdjsWeb.Router.Helpers
  alias Wsdjs.Accounts.User

  def user_displayed_name(%User{djname: djname}) when is_binary(djname), do: "#{djname}"
  def user_displayed_name(%User{name: name}) when is_binary(name), do: name
  def user_displayed_name(%User{email: email}), do: email

  def user_avatar_alt(user), do: "#{user.name}"

  def proposed_by_link(conn, %Wsdjs.Musics.Song{} = song) do
    Phoenix.HTML.Link.link(
      user_displayed_name(song.user),
      to: user_path(conn, :show, song.user.id),
      title: "suggested by #{song.user.name}, #{Timex.format!(song.inserted_at, "%b %d, %Y", :strftime)}",
      class: "visible-link clickable action-link"
    )
  end
end
