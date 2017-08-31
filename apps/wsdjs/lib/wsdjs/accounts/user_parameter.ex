defmodule Wsdjs.Accounts.UserParameter do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id
  schema "user_parameters" do
    field :new_song_notification, :boolean

    belongs_to :user, Wsdjs.Accounts.User

    timestamps()
  end

  @allowed_fields [:new_song_notification, :user_id]

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> assoc_constraint(:user)
  end
end
