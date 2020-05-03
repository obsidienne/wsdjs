defmodule Wsdjs.Attachments.Avatars.AvatarTest do
  use Wsdjs.DataCase

  alias Wsdjs.Attachments.Avatars.Avatar

  @create_attrs %{"cld_id" => "covers/gerkk29hk1t2ydaqlqyh", "version" => "1464527941"}
  @invalid_attrs %{"cld_id" => nil, "version" => nil}

  test "changeset with valid attributes" do
    changeset = Avatar.changeset(%Avatar{}, @create_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Avatar.changeset(%Avatar{}, @invalid_attrs)
    refute changeset.valid?
  end
end
