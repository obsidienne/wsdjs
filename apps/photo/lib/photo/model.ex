defmodule Photo.Model do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      
      import Ecto.Changeset
      import Ecto.Query

      alias Photo.{
        Photo
      }
    end
  end
end
