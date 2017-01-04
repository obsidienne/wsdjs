defmodule Wcsp.Song do
  use Wcsp.Model

  schema "songs" do
    field :title, :string
    field :artist, :string
    field :url, :string
    field :bpm, :integer
    field :genre, :string

    belongs_to :account, User.Account
    has_one :photo, Wcsp.Photo

    timestamps()
  end

  @allowed_fields [:title, :artist, :url, :bpm, :genre, :account_id]
  @required_fields [:title, :artist, :url, :genre]
  @validated_genre ~w(acoustic blues country dance hiphop jazz pop rnb rock soul)

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:title, name: :songs_title_artist_index)
    |> assoc_constraint(:account)
    |> validate_number(:bpm, greater_than: 0)
    |> validate_inclusion(:genre, @validated_genre)
    |> validate_url(:url)
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
