defmodule WsdjsWeb.UserView do
  use WsdjsWeb, :view

  def can_edit_page?(user, current_user) do
    current_user == user
  end
end
