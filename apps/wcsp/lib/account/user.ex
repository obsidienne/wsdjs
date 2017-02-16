defmodule Wcsp.User do
  use Wcsp.Model

  schema "users" do
    field :email, :string
    field :admin, :boolean
    field :new_song_notification, :boolean
    field :user_country, :string
    field :name, :string
    field :djname, :string

    has_many :songs, Wcsp.Song
    has_many :comments, Wcsp.SongComment
    has_one :avatar, Wcsp.Avatar
    timestamps()
  end

  @allowed_fields [:email, :new_song_notification, :user_country, :name, :djname]

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(:email)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/.*@.*/)
  end

  def build(%{email: email} = params) do
    changeset(%Wcsp.User{}, params)
  end
end
