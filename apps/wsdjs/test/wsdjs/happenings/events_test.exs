defmodule Wsdjs.Happenings.EventTest do
  use Wsdjs.DataCase
  import Wsdjs.Factory

  alias Wsdjs.Happenings

  describe "events" do
    alias Wsdjs.Happenings.Event

    @valid_attrs %{name: "event name"}
    @update_attrs %{name: "new event name"}
    @invalid_attrs %{name: ""}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Happenings.create_event()

      event
    end

    test "list_events/0 returns all events" do
      user = insert(:user)
      event = event_fixture(%{user_id: user.id})
      assert Happenings.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      user = insert(:user)
      event = event_fixture(%{user_id: user.id})
      assert Happenings.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      user = insert(:user)
      attrs = Enum.into(%{user_id: user.id}, @valid_attrs)

      assert {:ok, %Event{} = event} = Happenings.create_event(attrs)
      assert event.name == "event name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Happenings.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      user = insert(:user)
      event = event_fixture(%{user_id: user.id})

      assert {:ok, event} = Happenings.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.name == "new event name"
    end

    test "update_event/2 with invalid data returns error changeset" do
      user = insert(:user)
      event = event_fixture(%{user_id: user.id})

      assert {:error, %Ecto.Changeset{}} = Happenings.update_event(event, @invalid_attrs)
      assert event == Happenings.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      user = insert(:user)
      event = event_fixture(%{user_id: user.id})
      assert {:ok, %Event{}} = Happenings.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Happenings.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      user = insert(:user)
      event = event_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Happenings.change_event(event)
    end
  end
end
