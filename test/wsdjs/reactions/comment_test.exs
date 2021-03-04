defmodule Brididi.Reactions.CommentsTest do
  use Brididi.DataCase, async: true

  alias Brididi.Reactions.Comments.Comment

  @create_attrs %{text: "song title"}

  test "changeset with minimal valid attributes" do
    changeset = Comment.changeset(%Comment{}, @create_attrs)
    assert changeset.valid?
  end

  test "comment user and song must exist" do
    {:ok, dummy_id} = Brididi.HashID.load(999_999_999)

    params = Map.put(@create_attrs, :user_id, dummy_id)
    params = Map.put(params, :song_id, dummy_id)
    comment = Comment.changeset(%Comment{}, params)
    assert {:error, %{errors: [song: {"does not exist", _}]}} = Repo.insert(comment)
  end

  test "song comment length > 0" do
    comment = Comment.changeset(%Comment{}, %{text: ""})
    assert {:error, %{errors: [text: {"can't be blank", _}]}} = Repo.insert(comment)
  end
end
