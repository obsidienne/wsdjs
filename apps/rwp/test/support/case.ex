defmodule Rwp.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Rwp.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Rwp.Case

      use Rwp.Model
    end
  end
end
