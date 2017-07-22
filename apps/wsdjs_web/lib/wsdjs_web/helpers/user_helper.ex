defmodule Wsdjs.Web.UserHelper do
  @moduledoc """
  This modules contains all helpers for a %User{}.
  """
  import Wsdjs.Web.Router.Helpers
  alias Wsdjs.Accounts.User

  def user_displayed_name(%User{name: name, djname: djname}) when is_binary(djname) and is_binary(name), do: "#{name} (#{djname})"
  def user_displayed_name(%User{djname: djname}) when is_binary(djname), do: "#{djname}"
  def user_displayed_name(%User{name: name}) when is_binary(name), do: name
  def user_displayed_name(%User{email: email}), do: email

  def user_avatar_alt(user), do: "#{user.name}"

  def proposed_by_link(conn, %Wsdjs.Musics.Song{} = song) do
    Phoenix.HTML.Link.link(user_displayed_name(song.user),
                           to: user_path(conn, :show, song.user.id),
                           title: "#{song.user.name}")
  end
end
