defmodule Wcs.Model do
  @moduledoc false


  defmacro __using__(_) do
    @primary_key {:id, :binary_id, autogenerate: true}
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query

      alias Wcs.{
        Repo,
        Account
      }
    end
  end
end
