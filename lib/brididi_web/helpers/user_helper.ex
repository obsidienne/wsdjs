defmodule BrididiWeb.UserHelper do
  @moduledoc """
  This modules contains all helpers for a %User{}.
  """
  alias Brididi.Accounts.User

  def user_displayed_name(%User{email: email}), do: email
end
