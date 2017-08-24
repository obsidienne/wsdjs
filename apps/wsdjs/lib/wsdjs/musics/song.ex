defmodule Wsdjs.Musics.Song do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Wsdjs.Musics.Song

  alias Wsdjs.{Charts, Accounts, Musics}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "songs" do
    field :title, :string
    field :artist, :string
    field :url, :string
    field :bpm, :integer
    field :genre, :string
    field :instant_hit, :boolean
    field :hidden_track, :boolean
    field :video_id, :string
    field :public_track, :boolean
    timestamps()

    belongs_to :user, Accounts.User
    has_one :art, Musics.Art, on_replace: :delete
    has_many :comments, Musics.Comment
    has_many :ranks, Charts.Rank
    has_many :opinions, Musics.Opinion
    has_many :votes, Charts.Vote
    many_to_many :tops, Charts.Top, join_through: Charts.Rank
  end

  @allowed_fields [:title, :artist, :url, :bpm, :genre, :user_id, :instant_hit, :hidden_track, :inserted_at, :public_track]
  @required_fields [:title, :artist, :url, :genre]
  @validated_genre ~w(acoustic blues country dance hiphop jazz pop rnb rock soul)

  def changeset(%Song{} = song, attrs) do
    song
    |> cast(attrs, @allowed_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:title, name: :songs_title_artist_index)
    |> assoc_constraint(:user)
    |> cast_assoc(:art)
    |> validate_number(:bpm, greater_than: 0)
    |> validate_inclusion(:genre, @validated_genre)
    |> validate_url(:url)
    |> put_change(:video_id, Wsdjs.Helpers.Provider.extract(attrs["url"]))
  end

  def genre, do: @validated_genre

  # Admin sees everything
  def scoped(%Accounts.User{admin: :true}), do: Musics.Song

  # Connected user can see songs not explicitly track
  def scoped(%Accounts.User{} = user) do
    if Enum.member?(user.profils, "DJ_VIP") do
      from s in Musics.Song,
      where: s.user_id == ^user.id or s.public_track == true
    else
      from s in Musics.Song,
      where: s.user_id == ^user.id or s.public_track == true
    end
  end

  # Not connected users see only top 10 song or instant_hit
  def scoped(nil) do
    from s in Musics.Song,
    left_join: r in assoc(s, :ranks),
    where: (r.position <= 10 or s.instant_hit == true or s.public_track == true)
  end

  # This function validates the format of an URL not it's validity.
  defp validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_char_list |> :http_uri.parse do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || "invalid url: #{inspect msg}"}]
      end
    end
  end
end
