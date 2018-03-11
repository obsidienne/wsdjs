defmodule Wsdjs.Happenings.VenueTest do
  use Wsdjs.DataCase

  alias Wsdjs.Happenings

  describe "venues" do
    alias Wsdjs.Happenings.Venue

    @valid_attrs %{name: "venue name"}
    @update_attrs %{name: "new venue name"}
    @invalid_attrs %{name: ""}

    def venue_fixture(attrs \\ %{}) do
      {:ok, event} = Happenings.create_venue(venue_fixture_attrs(attrs))

      event
    end

    def venue_fixture_attrs(attrs \\ %{}) do
      {:ok, user} =
        Wsdjs.Accounts.create_user(%{email: "dummy#{System.unique_integer()}@bshit.com"})

      attrs
      |> Enum.into(@valid_attrs)
      |> Map.put(:user_id, user.id)
    end

    test "list_venues/0 returns all venues" do
      venue = venue_fixture()
      assert Happenings.list_venues() == [venue]
    end

    test "get_venue!/1 returns the venue with given id" do
      venue = venue_fixture()
      assert Happenings.get_venue!(venue.id) == venue
    end

    test "create_venue/1 with valid data creates a venue" do
      assert {:ok, %Venue{} = venue} = Happenings.create_venue(venue_fixture_attrs())
      assert venue.name == "venue name"
    end

    test "create_venue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Happenings.create_venue(@invalid_attrs)
    end

    test "update_venue/2 with valid data updates the venue" do
      venue = venue_fixture()

      assert {:ok, venue} = Happenings.update_venue(venue, @update_attrs)
      assert %Venue{} = venue
      assert venue.name == "new venue name"
    end

    test "update_venue/2 with invalid data returns error changeset" do
      venue = venue_fixture()
      assert {:error, %Ecto.Changeset{}} = Happenings.update_venue(venue, @invalid_attrs)
      assert venue == Happenings.get_venue!(venue.id)
    end

    test "delete_venue/1 deletes the venue" do
      venue = venue_fixture()
      assert {:ok, %Venue{}} = Happenings.delete_venue(venue)
      assert_raise Ecto.NoResultsError, fn -> Happenings.get_venue!(venue.id) end
    end

    test "change_venue/1 returns a venue changeset" do
      venue = venue_fixture()
      assert %Ecto.Changeset{} = Happenings.change_venue(venue)
    end
  end
end
