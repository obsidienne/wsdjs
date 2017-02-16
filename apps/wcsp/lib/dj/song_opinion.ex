defmodule Wcsp.SongOpinion do
  use Wcsp.Model

  schema "song_opinions" do
    field :kind, :string

    belongs_to :user, Wcsp.User
    belongs_to :song, Wcsp.Song

    timestamps()
  end

  @allowed_fields ~w(kind)
  @validated_opinions ~w(up like down)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required([:kind])
    |> validate_inclusion(:kind, @validated_opinions)
    |> assoc_constraint(:user)
    |> assoc_constraint(:song)
  end
end
