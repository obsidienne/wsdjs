defmodule Wcsp.Musics.Opinion do
  use Wcsp.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "song_opinions" do
    field :kind, :string

    belongs_to :user, Wcsp.User
    belongs_to :song, Wcsp.Musics.Song

    timestamps()
  end

  @allowed_fields [:kind, :user_id, :song_id]
  @validated_opinions ~w(up like down)

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required([:kind])
    |> validate_inclusion(:kind, @validated_opinions)
    |> unique_constraint(:song_id, name: :song_opinions_user_id_song_id_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:song)
  end

  def build(%{kind: kind, user_id: user_id, song_id: song_id} = params) do
    changeset(%Wcsp.Musics.Opinion{}, params)
  end

end
