defmodule Wsdjs.Accounts.UserParameter do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Accounts.UserParameter

  @foreign_key_type :binary_id
  schema "user_parameters" do
    field :new_song_notification, :boolean
    field :piwik, :boolean
    field :video, :boolean

    belongs_to :user, Wsdjs.Accounts.User

    timestamps()
  end

  @allowed_fields [:new_song_notification, :user_id, :piwik, :video]

  @doc false
  def changeset(%UserParameter{} = user_parameter, attrs) do
    user_parameter
    |> cast(attrs, @allowed_fields)
    |> assoc_constraint(:user)
  end
end
