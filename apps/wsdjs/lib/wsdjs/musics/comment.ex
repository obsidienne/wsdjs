defmodule Wsdjs.Musics.Comment do
  @moduledoc """
  This module contains the comments on music mapping struct.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :text, :string

    belongs_to :user, Wsdjs.Accounts.User
    belongs_to :song, Wsdjs.Musics.Song
    timestamps()
  end

  @allowed_fields [:text, :user_id, :song_id]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(:text)
    |> validate_length(:text, min: 1)
    |> assoc_constraint(:user)
    |> assoc_constraint(:song)
  end
end
