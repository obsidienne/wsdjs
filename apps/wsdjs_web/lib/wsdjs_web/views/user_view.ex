defmodule Wsdjs.Web.UserView do
  use Wsdjs.Web, :view

  def can_edit_page?(user, current_user) do
    current_user == user
  end
end
