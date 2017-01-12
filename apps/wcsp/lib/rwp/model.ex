defmodule Wcsp.Model do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query

      alias Wcsp.{
        AlbumArt,
        Avatar,
        Song,
        Top,
        Account,
        Comment,
        Rank
      }

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
