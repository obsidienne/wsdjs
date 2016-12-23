defmodule User.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias User.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import User.Case

      use User.Model
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(User.Repo)
    :ok
  end
end
