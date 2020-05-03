defmodule WsdjsWeb.SongActionsView do
  use WsdjsWeb, :view

  alias Wsdjs.Accounts

  def list_users do
    users = Accounts.list_users()
    Enum.map(users, &{user_displayed_name(&1), &1.id})
  end
end
