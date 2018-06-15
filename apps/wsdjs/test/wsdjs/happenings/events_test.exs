defmodule Wsdjs.Happenings.EventTest do
  use Wsdjs.DataCase
  alias Wsdjs.Happenings

  describe "events" do
    alias Wsdjs.Happenings.Event

    @valid_attrs %{
      name: "event name",
      starts_on: ~N[2000-01-01 23:00:07],
      ends_on: ~N[2000-01-04 23:00:07],
      lng: 2.40603,
      lat: 48.8489,
      venue: "testouille"
    }
    @update_attrs %{name: "new event name"}
    @invalid_attrs %{name: ""}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} = Happenings.create_event(event_fixture_attrs(attrs))

      event
    end

    def event_fixture_attrs(attrs \\ %{}) do
      {:ok, user} =
        Wsdjs.Accounts.create_user(%{email: "dummy#{System.unique_integer()}@bshit.com"})

      attrs
      |> Enum.into(@valid_attrs)
      |> Map.put(:user_id, user.id)
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Happenings.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Happenings.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Happenings.create_event(event_fixture_attrs())
      assert event.name == "event name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Happenings.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      assert {:ok, event} = Happenings.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.name == "new event name"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()

      assert {:error, %Ecto.Changeset{}} = Happenings.update_event(event, @invalid_attrs)
      assert event == Happenings.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Happenings.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Happenings.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Happenings.change_event(event)
    end
  end
end
