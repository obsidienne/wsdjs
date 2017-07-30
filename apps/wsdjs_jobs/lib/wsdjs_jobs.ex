defmodule Wsdjs.Jobs do
  @moduledoc """
  A module that keeps using definitions for views.

  This can be used in your application as:

      use Wsdjs.Jobs, :view

  The definitions below will be executed for every view 
  so keep them short and clean, focused on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def view do
    quote do
      use Phoenix.View, root: "lib/wsdjs_jobs/templates",
                        namespace: Wsdjs.Jobs
    end
  end

  @doc """
  When used, dispatch to the appropriate view.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
