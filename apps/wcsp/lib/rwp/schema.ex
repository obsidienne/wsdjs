defmodule Wcsp.Schema do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query

      alias Wcsp.{
        Repo,
        Top,
        Rank
      }
    end
  end
end
