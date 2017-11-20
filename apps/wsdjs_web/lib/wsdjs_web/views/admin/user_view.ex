defmodule WsdjsWeb.Admin.UserView do
  use WsdjsWeb, :view

  alias Wsdjs.Accounts.User

  def name_or_email(%User{email: email, name: nil, djname: nil}), do: email
  def name_or_email(%User{email: email, name: name}) when is_binary(name), do: name
  def name_or_email(%User{email: email, djname: djname}) when is_binary(djname), do: djname
end
