defmodule Dj.Song do
  use Dj.Model

  schema "songs" do
    field :title, :string
    field :artist, :string
    field :url, :string
    field :bpm, :integer
    field :genre, :string

    belongs_to :user, Wcs.User
    has_one :photo, Photo.Photo
  end

  @required_fields ~w(title artist)
  @validated_genre ~w(acoustic blues country dance hiphop jazz pop rnb rock soul)

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields)
    |> validate_required(~w(title artist)a)
    |> unique_constraint([:title, :artist])
    |> assoc_constraint(:user)
    |> validate_number(:bpm, greater_than: 0)
    |> validate_inclusion(:genre, @validated_genre)
  end
end
