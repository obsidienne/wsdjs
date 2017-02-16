defmodule Wcsp.SongCommentTest do
  use Wcsp.Case, async: true

  @valid_attrs %{text: "song title"}

  test "changeset with minimal valid attributes" do
    changeset = SongComment.changeset(%SongComment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "comment user and song must exist" do
    params = Map.put(@valid_attrs, :user_id, Ecto.UUID.generate())
    params = Map.put(params, :song_id, Ecto.UUID.generate())
    comment = SongComment.changeset(%SongComment{}, params)
    assert {:error, %{errors: [user: {"does not exist", _}]}} = Repo.insert(comment)
  end
end
