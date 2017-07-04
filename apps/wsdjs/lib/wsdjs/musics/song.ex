defmodule Wsdjs.Musics.Song do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Wsdjs.Repo

  alias Wsdjs.Trendings
  alias Wsdjs.Accounts
  alias Wsdjs.Musics

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "songs" do
    field :title, :string
    field :artist, :string
    field :url, :string
    field :bpm, :integer
    field :genre, :string
    field :instant_hit, :boolean
    field :hidden, :boolean

    belongs_to :user, Accounts.User
    has_one :art, Musics.Art, on_replace: :delete
    has_many :comments, Musics.Comment
    has_many :ranks, Trendings.Rank
    has_many :opinions, Musics.Opinion
    has_many :votes, Trendings.Vote
    many_to_many :tops, Trendings.Top, join_through: Trendings.Rank

    timestamps()

    embeds_many :providers, Provider, on_replace: :delete, primary_key: false do
      field :url, :string
      field :provider_type, :string
      field :provider_id, :string
    end
  end

  @allowed_fields [:title, :artist, :url, :bpm, :genre, :user_id, :instant_hit, :hidden]
  @required_fields [:title, :artist, :url, :genre]
  @validated_genre ~w(acoustic blues country dance hiphop jazz pop rnb rock soul)

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:title, name: :songs_title_artist_index)
    |> assoc_constraint(:user)
    |> cast_assoc(:art)
    |> validate_number(:bpm, greater_than: 0)
    |> validate_inclusion(:genre, @validated_genre)
    |> validate_url(:url)
  end

  def genre, do: @validated_genre


  @doc """
  Admin sees everything
  """
  def scoped(%Accounts.User{admin: :true}), do: Musics.Song

  @doc """
  Connected user can see songs not explicitly hidden
  """
  def scoped(%Accounts.User{} = user) do
    from s in Musics.Song,
    where: s.hidden == false or s.user_id == ^user.id
  end

  @doc """
  Not connected users see only top 10 song or instant_hit
  """
  def scoped(nil) do
    from s in Musics.Song,
    join: r in assoc(s, :ranks),
    where: r.position <= 10 or s.instant_hit == true
  end

  defp validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_char_list |> :http_uri.parse do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || "invalid url: #{inspect msg}"}]
      end
    end
  end
end
