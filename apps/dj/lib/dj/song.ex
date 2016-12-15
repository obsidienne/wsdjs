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

  @allowed_fields ~w(title artist url bpm genre)a
  @required_fields ~w(title artist)a
  @validated_genre ~w(acoustic blues country dance hiphop jazz pop rnb rock soul)a

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:title, name: :songs_title_artist_index)
    |> assoc_constraint(:user)
    |> validate_number(:bpm, equal_to: 0)
    |> validate_inclusion(:genre, @validated_genre)
  end
end
