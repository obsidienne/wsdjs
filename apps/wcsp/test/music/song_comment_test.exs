defmodule Wcsp.SongCommentTest do
  use Wcsp.DataCase, async: true

  alias Wcsp.SongComment

  @create_attrs %{text: "song title"}

  test "changeset with minimal valid attributes" do
    changeset = SongComment.changeset(%SongComment{}, @create_attrs)
    assert changeset.valid?
  end

  test "comment user and song must exist" do
    params = Map.put(@create_attrs, :user_id, Ecto.UUID.generate())
    params = Map.put(params, :song_id, Ecto.UUID.generate())
    comment = SongComment.changeset(%SongComment{}, params)
    assert {:error, %{errors: [user: {"does not exist", _}]}} = Repo.insert(comment)
  end

  test "song comment length > 0" do
    comment = SongComment.changeset(%SongComment{}, %{text: ""})
    assert {:error, %{errors: [text: {"can't be blank", _}]}} = Repo.insert(comment)
  end
end
