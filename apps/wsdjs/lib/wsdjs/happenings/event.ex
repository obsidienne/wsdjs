defmodule Wsdjs.Happenings.Event do
  @moduledoc """
  An event is a logical group of happenings. Generally, an event
  contains several parties, competitions and workshops
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Happenings.Event

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :name, :string
    belongs_to :user, Wsdjs.Accounts.User
    
    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name])
  end
end
