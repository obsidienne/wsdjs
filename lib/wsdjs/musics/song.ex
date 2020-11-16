defmodule Wsdjs.Musics.Song do
  use Ecto.Schema
  import Ecto.Changeset

  alias Wsdjs.Accounts
  alias Wsdjs.Charts
  alias Wsdjs.Reactions.{Comments, Opinions}

  @validated_genre ~w(acoustic blues country dance hiphop jazz pop rnb rock soul)

  @primary_key {:id, Wsdjs.HashID, autogenerate: true}
  schema "songs" do
    field(:title, :string)
    field(:artist, :string)
    field(:url, :string)
    field(:bpm, :integer, default: 0)
    field(:genre, :string)
    field(:instant_hit, :boolean, default: false)
    field(:hidden_track, :boolean, default: false)
    field(:video_id, :string)
    field(:public_track, :boolean, default: false)
    field(:cld_id, :string, default: "wsdjs/missing_cover.jpg")
    timestamps()

    belongs_to(:user, Accounts.User, type: Wsdjs.HashID)
    has_many(:comments, Comments.Comment)
    has_many(:ranks, Charts.Rank)
    has_many(:opinions, Opinions.Opinion)
    has_many(:votes, Charts.Vote)
    many_to_many(:tops, Charts.Top, join_through: Charts.Rank)
  end

  def create_changeset(%__MODULE__{} = song, attrs) do
    song
    |> cast(attrs, [:title, :artist, :url, :bpm, :genre, :user_id])
    |> validate_required([:title, :artist, :url, :bpm, :genre, :user_id])
    |> unique_constraint(:title, name: :songs_title_artist_index)
    |> assoc_constraint(:user)
    |> validate_number(:bpm, greater_than: 0)
    |> validate_inclusion(:genre, @validated_genre)
    |> put_change(:video_id, Wsdjs.Attachments.Provider.extract(attrs["url"]))
  end

  def update_changeset(%__MODULE__{} = song, attrs) do
    song
    |> cast(attrs, [
      :title,
      :artist,
      :url,
      :bpm,
      :genre,
      :instant_hit,
      :hidden_track,
      :public_track,
      :inserted_at
    ])
    |> validate_required([:url, :bpm, :genre])
    |> unique_constraint(:title, name: :songs_title_artist_index)
    |> assoc_constraint(:user)
    |> validate_number(:bpm, greater_than: 0)
    |> validate_inclusion(:genre, @validated_genre)
    |> put_change(:video_id, Wsdjs.Attachments.Provider.extract(attrs["url"]))
  end

  def genre, do: @validated_genre
end
