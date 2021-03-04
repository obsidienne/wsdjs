defmodule BrididiWeb.UserView do
  use BrididiWeb, :view

  alias Brididi.Accounts.User

  def name_or_email(%User{email: email}), do: email
end
