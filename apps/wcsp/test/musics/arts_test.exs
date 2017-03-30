defmodule Wcsp.ArtsTest do
  use Wcsp.DataCase

  alias Wcsp.Musics.Arts

  @create_attrs %{cld_id: "covers/gerkk29hk1t2ydaqlqyh", version: "1464527941"}
  @invalid_attrs %{cld_id: nil, version: nil}

  test "changeset with valid attributes" do
    changeset = Arts.changeset(%Arts{}, @create_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Arts.changeset(%Arts{}, @invalid_attrs)
    refute changeset.valid?
  end
end
