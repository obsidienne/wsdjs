defmodule WsdjsApi.UserHelper do
  @moduledoc """
  This modules contains all helpers for a %User{}.
  """
  alias Wsdjs.Accounts.User

  def user_displayed_name(%User{name: name, djname: djname}) when is_binary(djname) and is_binary(name), do: "#{name} (#{djname})"
  def user_displayed_name(%User{djname: djname}) when is_binary(djname), do: "#{djname}"
  def user_displayed_name(%User{name: name}) when is_binary(name), do: name
  def user_displayed_name(%User{email: email}), do: email
end
