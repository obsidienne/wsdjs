defmodule WsdjsWeb.UserView do
  use WsdjsWeb, :view

  alias Wsdjs.Accounts.User

  def name_or_email(%User{email: email}), do: email
end
