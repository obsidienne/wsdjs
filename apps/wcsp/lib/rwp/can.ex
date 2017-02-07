defmodule Wscp.Can do
  use Wcsp.Model

  def can?(%User{}, action, %Song{}) when action in [:update, :show], do: true
end
