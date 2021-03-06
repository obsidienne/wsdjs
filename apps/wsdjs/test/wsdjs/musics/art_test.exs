defmodule Wsdjs.Attachments.Arts.ArtTest do
  use Wsdjs.DataCase

  alias Wsdjs.Attachments.Arts.Art

  @create_attrs %{cld_id: "covers/gerkk29hk1t2ydaqlqyh", version: "1464527941"}
  @invalid_attrs %{cld_id: nil, version: nil}

  test "changeset with valid attributes" do
    changeset = Art.changeset(%Art{}, @create_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Art.changeset(%Art{}, @invalid_attrs)
    refute changeset.valid?
  end
end
