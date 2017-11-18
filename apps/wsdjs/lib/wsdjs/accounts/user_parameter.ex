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
    field :radioking_unmatch, :boolean

    belongs_to :user, Wsdjs.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%UserParameter{} = user_parameter, attrs) do
    user_parameter
    |> cast(attrs, [:new_song_notification])
    |> assoc_constraint(:user)
  end

  @doc false
  def admin_changeset(%UserParameter{} = user_parameter, attrs) do
    user_parameter
    |> cast(attrs, [:new_song_notification, :piwik, :video, :radioking_unmatch])
    |> assoc_constraint(:user)
  end
end
