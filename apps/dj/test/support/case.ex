defmodule Dj.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Dj.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Dj.Case

      use Dj.Model
    end
  end

  setup tags do
    opts = tags |> Map.take([:isolation]) |> Enum.to_list()
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Dj.Repo, opts)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Wcs.Repo, opts)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Dj.Repo, {:shared, self()})
      Ecto.Adapters.SQL.Sandbox.mode(Wcs.Repo, {:shared, self()})
    end

    :ok
  end
end
