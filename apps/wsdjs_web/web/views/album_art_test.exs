defmodule Wcsp.AlbumArtTest do
  use Wcsp.Case

  @valid_attrs %{cld_id: "covers/gerkk29hk1t2ydaqlqyh", version: "1464527941"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AlbumArt.changeset(%AlbumArt{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AlbumArt.changeset(%AlbumArt{}, @invalid_attrs)
    refute changeset.valid?
  end
end
