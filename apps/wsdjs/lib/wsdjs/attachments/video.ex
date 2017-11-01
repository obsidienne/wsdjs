defmodule Wsdjs.Attachments.Video do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Attachments.Video

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "videos" do
    field :url, :string
    field :video_id, :string
    field :title, :string
    field :event, :string

    belongs_to :user, Wsdjs.Accounts.User
    belongs_to :song, Wsdjs.Musics.Song
    timestamps()
  end

  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, [:url, :event, :title, :user_id, :song_id])
    |> validate_required(:url)
    |> assoc_constraint(:user)
    |> assoc_constraint(:song)
    |> put_change(:video_id, Wsdjs.Helpers.Provider.extract(attrs["url"]))
  end
end
