defmodule Wsdjs.Web.UserView do
  use Wsdjs.Web, :view

  def can_edit_page?(user, current_user) do
    current_user == user
  end

  def has_description?(user) do
    user.description != nil && String.length(user.description) > 0
  end
end
