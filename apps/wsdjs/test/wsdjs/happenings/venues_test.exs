defmodule Wsdjs.Happenings.VenueTest do
  use Wsdjs.DataCase
  import Wsdjs.Factory
  
  alias Wsdjs.Happenings

  describe "venues" do
    alias Wsdjs.Happenings.Venue

    @valid_attrs %{name: "venue name"}
    @update_attrs %{name: "new venue name"}
    @invalid_attrs %{name: ""}

    def venue_fixture(attrs \\ %{}) do
      {:ok, venue} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Happenings.create_venue()

      venue
    end

    test "list_venues/0 returns all venues" do
      user = insert(:user)
      venue = venue_fixture(%{user_id: user.id})
      assert Happenings.list_venues() == [venue]
    end

    test "get_venue!/1 returns the venue with given id" do
      user = insert(:user)
      venue = venue_fixture(%{user_id: user.id})
      assert Happenings.get_venue!(venue.id) == venue
    end

    test "create_venue/1 with valid data creates a venue" do
      user = insert(:user)
      attrs = Enum.into(%{user_id: user.id}, @valid_attrs)

      assert {:ok, %Venue{} = venue} = Happenings.create_venue(attrs)
      assert venue.name == "venue name"
    end

    test "create_venue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Happenings.create_venue(@invalid_attrs)
    end

    test "update_venue/2 with valid data updates the venue" do
      user = insert(:user)
      venue = venue_fixture(%{user_id: user.id})

      assert {:ok, venue} = Happenings.update_venue(venue, @update_attrs)
      assert %Venue{} = venue
      assert venue.name == "new venue name"
    end

    test "update_venue/2 with invalid data returns error changeset" do
      user = insert(:user)
      venue = venue_fixture(%{user_id: user.id})

      assert {:error, %Ecto.Changeset{}} = Happenings.update_venue(venue, @invalid_attrs)
      assert venue == Happenings.get_venue!(venue.id)
    end

    test "delete_venue/1 deletes the venue" do
      user = insert(:user)
      venue = venue_fixture(%{user_id: user.id})
      assert {:ok, %Venue{}} = Happenings.delete_venue(venue)
      assert_raise Ecto.NoResultsError, fn -> Happenings.get_venue!(venue.id) end
    end

    test "change_venue/1 returns a venue changeset" do
      user = insert(:user)
      venue = venue_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Happenings.change_venue(venue)
    end
  end
end
