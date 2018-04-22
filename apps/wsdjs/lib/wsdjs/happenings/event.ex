defmodule Wsdjs.Happenings.Event do
  @moduledoc """
  An event is a logical group of happenings. Generally, an event
  contains several parties, competitions and workshops
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Happenings.Event

  @primary_key {:id, Wsdjs.HashID, read_after_writes: true}
  schema "events" do
    field(:name, :string)
    field(:starts_on, :date)
    field(:ends_on, :date)

    field(:venue, :string)
    field(:coordinates, Geo.Point)     # add the actual column
    field(:lng, :float, virtual: true) # add the virtual flag here and below
    field(:lat, :float, virtual: true)

    belongs_to(:user, Wsdjs.Accounts.User, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:name, :user_id, :starts_on, :ends_on, :lng, :lat, :venue])
    |> validate_required([:name, :starts_on, :ends_on, :lng, :lat, :venue])
    |> assoc_constraint(:user)
    |> cast_coordinates()
  end

  def cast_coordinates(changeset) do
    lat = get_change(changeset, :lat)
    lng = get_change(changeset, :lng)
    geo = %Geo.Point{coordinates: {lng, lat}, srid: 4326}
    changeset |> put_change(:coordinates, geo)
  end
end
