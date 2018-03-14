defmodule Wsdjs.Happenings.Event do
  @moduledoc """
  An event is a logical group of happenings. Generally, an event
  contains several parties, competitions and workshops
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Happenings.Event

  schema "events" do
    field(:name, :string)
    field(:starts_on, :date)
    field(:ends_on, :date)
    belongs_to(:user, Wsdjs.Accounts.User, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:name, :user_id, :starts_on, :ends_on])
    |> validate_required([:name, :starts_on, :ends_on])
    |> assoc_constraint(:user)
  end
end
