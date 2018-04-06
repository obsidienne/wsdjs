defmodule Wsdjs.Attachments.Video do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Attachments.Video

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "videos" do
    field(:url, :string)
    field(:video_id, :string)
    field(:title, :string)
    field(:event_str, :string, source: :event)
    field(:published_at, :date)
    field(:provider, :string, default: "unknown")

    belongs_to(:user, Wsdjs.Accounts.User)
    belongs_to(:song, Wsdjs.Musics.Song)
    belongs_to(:event, Wsdjs.Happenings.Event, type: Wsdjs.HashID)
    timestamps()
  end

  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, [:url, :event_str, :event_id, :title, :user_id, :song_id, :published_at])
    |> validate_required(:url)
    |> assoc_constraint(:user)
    |> validate_url(:url)
    |> assoc_constraint(:song)
    |> put_change(:video_id, Wsdjs.Attachments.Provider.extract(attrs["url"]))
    |> put_change(:provider, Wsdjs.Attachments.Provider.type(attrs["url"]))
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
