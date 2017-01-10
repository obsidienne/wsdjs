defmodule Wscp.Can do
  use Wcsp.Model

  def can?(%Account{}, action, %Song{}) when action in [:update, :show], do: true
end
