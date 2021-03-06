defmodule Wsdjs.Accounts.UserParameter do
  @moduledoc false
  use Wsdjs.Schema
  import Ecto.Changeset

  schema "user_parameters" do
    field(:new_song_notification, :boolean, default: false)
    field(:piwik, :boolean, default: true)
    field(:video, :boolean, default: false)
    field(:radioking_unmatch, :boolean, default: false)
    field(:email_contact, :boolean, default: false)

    belongs_to(:user, Wsdjs.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = user_parameter, attrs) do
    user_parameter
    |> cast(attrs, [:new_song_notification, :email_contact])
    |> assoc_constraint(:user)
  end

  @doc false
  def admin_changeset(%__MODULE__{} = user_parameter, attrs) do
    user_parameter
    |> cast(attrs, [
      :new_song_notification,
      :piwik,
      :video,
      :radioking_unmatch,
      :email_contact
    ])
    |> assoc_constraint(:user)
  end
end
