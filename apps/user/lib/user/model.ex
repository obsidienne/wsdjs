defmodule User.Model do
  @moduledoc false

  @primary_key {:id, :binary_id, autogenerate: true}

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query


      alias User.{
        User
      }
    end
  end
end
