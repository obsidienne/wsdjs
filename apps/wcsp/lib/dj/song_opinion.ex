defmodule Wcsp.SongOpinion do
  use Wcsp.Model

  schema "song_opinions" do
    field :kind, :string

    belongs_to :user, Wcsp.User
    belongs_to :song, Wcsp.Song

    timestamps()
  end

  @allowed_fields [:kind, :user_id, :song_id]
  @validated_opinions ~w(up like down)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required([:kind])
    |> validate_inclusion(:kind, @validated_opinions)
    |> unique_constraint(:song_id, name: :song_opinions_user_id_song_id_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:song)
  end

  def build(%{kind: kind, user_id: user_id, song_id: song_id} = params) do
    changeset(%SongOpinion{}, params)
  end

end
