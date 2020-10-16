defmodule Wsdjs.Attachments.Videos.Video do
  @moduledoc """
  A video attached to a song and maybe an event.
  """
  use Wsdjs.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer,
          url: String.t(),
          video_id: String.t(),
          title: String.t(),
          event_str: String.t(),
          published_at: Date.t(),
          provider: String.t(),
          updated_at: DateTime.t(),
          inserted_at: DateTime.t()
        }

  @allowed_fields ~w(url event_str event_id title user_id song_id published_at)a
  @required_fields ~w(url)a

  schema "videos" do
    field(:url, :string)
    field(:video_id, :string)
    field(:title, :string)
    field(:event_str, :string, source: :event)
    field(:published_at, :date)
    field(:provider, :string, default: "unknown")

    belongs_to(:user, Wsdjs.Accounts.User)
    belongs_to(:song, Wsdjs.Songs.Song)
    belongs_to(:event, Wsdjs.Happenings.Event)
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
