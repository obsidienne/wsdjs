defmodule Wcsp.CommentsTest do
  use Wcsp.DataCase, async: true

  alias Wcsp.Musics.
  Comments

  @create_attrs %{text: "song title"}

  test "changeset with minimal valid attributes" do
    changeset = Comments.changeset(%Comments{}, @create_attrs)
    assert changeset.valid?
  end

  test "comment user and song must exist" do
    params = Map.put(@create_attrs, :user_id, Ecto.UUID.generate())
    params = Map.put(params, :song_id, Ecto.UUID.generate())
    comment = Comments.changeset(%Comments{}, params)
    assert {:error, %{errors: [user: {"does not exist", _}]}} = Repo.insert(comment)
  end

  test "song comment length > 0" do
    comment = Comments.changeset(%Comments{}, %{text: ""})
    assert {:error, %{errors: [text: {"can't be blank", _}]}} = Repo.insert(comment)
  end
end
