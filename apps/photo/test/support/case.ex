defmodule Photo.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Photo.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Photo.Case

      use Photo.Model
    end
  end
end
