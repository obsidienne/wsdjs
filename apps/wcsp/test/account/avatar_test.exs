defmodule Wcsp.AvatarTest do
  use Wcsp.DataCase

  alias Wcsp.Avatar

  @valid_attrs %{cld_id: "covers/gerkk29hk1t2ydaqlqyh", version: "1464527941"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Avatar.changeset(%Avatar{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Avatar.changeset(%Avatar{}, @invalid_attrs)
    refute changeset.valid?
  end
end
