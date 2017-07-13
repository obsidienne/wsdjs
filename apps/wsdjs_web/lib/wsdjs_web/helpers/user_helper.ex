defmodule Wsdjs.Web.UserHelper do
  @moduledoc """
  This modules contains all helpers for a %User{}.
  """
  alias Wsdjs.Accounts.User

  def user_displayed_name(%User{name: name, djname: djname}) when is_binary(djname), do: "#{name} (#{djname})"
  def user_displayed_name(%User{name: name}), do: name

  def user_avatar_alt(user), do: "#{user.name}"

  def user_description_available?(user) do
    user.description != nil && String.length(user.description) > 0
  end

  def user_djname_available?(user) do
    user.djname != nil && String.length(user.djname) > 0
  end

  def user_suggested_songs_available?(songs) do
    length(songs) > 0
  end

  def can_edit_page?(user, current_user) do
    current_user == user
  end

  def has_description?(user) do
    user.description != nil && String.length(user.description) > 0
  end
end
