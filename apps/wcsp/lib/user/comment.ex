defmodule Wcsp.Comment do
  use Wcsp.Model

  schema "comments" do
    field :text, :string

    belongs_to :account, Wcsp.Account
    belongs_to :song, Wcsp.Song
    timestamps()
  end

  @allowed_fields [:text, :account_id, :song_id]

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(:text)
    |> assoc_constraint(:account)
    |> assoc_constraint(:song)
  end
end
