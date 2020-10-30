defmodule WsdjsWeb.UserHelper do
  @moduledoc """
  This modules contains all helpers for a %User{}.
  """
  alias Wsdjs.Accounts.User

  def user_displayed_name(%User{email: email}), do: email
end
