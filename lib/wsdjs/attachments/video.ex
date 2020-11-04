defmodule Wsdjs.Attachments.Videos.Video do
  @moduledoc """
  A video attached to a song.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_fields ~w(url title user_id song_id published_at)a
  @required_fields ~w(url)a

  @primary_key {:id, Wsdjs.HashID, autogenerate: true}
  schema "videos" do
    field(:url, :string)
    field(:video_id, :string)
    field(:title, :string)
    field(:published_at, :date)
    field(:provider, :string, default: "unknown")

    belongs_to(:user, Wsdjs.Accounts.User, type: Wsdjs.HashID)
    belongs_to(:song, Wsdjs.Songs.Song, type: Wsdjs.HashID)
    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = video, attrs) do
    video
    |> cast(attrs, @allowed_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
    |> validate_url(:url)
    |> assoc_constraint(:song)
    |> put_change(:video_id, Wsdjs.Attachments.Provider.extract(attrs["url"]))
    |> put_change(:provider, Wsdjs.Attachments.Provider.type(attrs["url"]))
    |> validate_required(:provider)
  end

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
