defmodule Dj.Model do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query

      alias Dj.{
        Song,
        Top
      }
    end
  end
end
