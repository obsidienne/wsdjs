defmodule Wcs.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Wcs.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Wcs.Case

      use Wcs.Model
    end
  end
end
