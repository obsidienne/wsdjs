defmodule Wcsp.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Wcsp.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Wcsp.Case

      use Wcsp.Model
    end
  end
end
