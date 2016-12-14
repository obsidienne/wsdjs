defmodule Photo.PhotoTest do
  use Photo.Case

  @valid_attrs %{cld_id: "covers/gerkk29hk1t2ydaqlqyh", version: "1464527941"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Photo.changeset(%Photo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Photo.changeset(%Photo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
