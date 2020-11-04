defmodule Wsdjs.Songs.Song do
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
    field(:suggestion, :boolean, default: true)
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
    |> validate_url(:url)
    |> put_change(:video_id, Wsdjs.Attachments.Provider.extract(attrs["url"]))
    |> put_change(:suggestion, false)
  end

  def suggestion_changeset(%__MODULE__{} = song, attrs) do
    song
    |> cast(attrs, [:title, :artist, :url, :bpm, :genre, :user_id])
    |> validate_required([:title, :artist, :url, :bpm, :genre, :user_id])
    |> unique_constraint(:title, name: :songs_title_artist_index)
    |> assoc_constraint(:user)
    |> validate_number(:bpm, greater_than: 0)
    |> validate_inclusion(:genre, @validated_genre)
    |> validate_url(:url)
    |> put_change(:video_id, Wsdjs.Attachments.Provider.extract(attrs["url"]))
    |> put_change(:suggestion, true)
  end

  def update_changeset(%__MODULE__{} = song, attrs) do
    song
    |> cast(attrs, [:url, :bpm, :genre, :hidden_track, :public_track])
    |> validate_required([:url, :bpm, :genre])
    |> unique_constraint(:title, name: :songs_title_artist_index)
    |> assoc_constraint(:user)
    |> validate_number(:bpm, greater_than: 0)
    |> validate_inclusion(:genre, @validated_genre)
    |> validate_url(:url)
    |> put_change(:video_id, Wsdjs.Attachments.Provider.extract(attrs["url"]))
  end

  def admin_changeset(%__MODULE__{} = song, attrs) do
    song
    |> cast(attrs, [
      :title,
      :artist,
      :url,
      :bpm,
      :genre,
      :user_id,
      :instant_hit,
      :hidden_track,
      :inserted_at,
      :public_track,
      :suggestion
    ])
    |> validate_required([:url, :bpm, :genre])
    |> unique_constraint(:title, name: :songs_title_artist_index)
    |> assoc_constraint(:user)
    |> validate_number(:bpm, greater_than: 0)
    |> validate_inclusion(:genre, @validated_genre)
    |> validate_url(:url)
    |> put_change(:video_id, Wsdjs.Attachments.Provider.extract(attrs["url"]))
  end

  def genre, do: @validated_genre

  # This function validates the format of an URL not it's validity.
  defp validate_url(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, url ->
      case url |> String.to_charlist() |> :http_uri.parse() do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || "invalid url: #{inspect(msg)}"}]
      end
    end)
  end
end
