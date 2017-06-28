defmodule Wsdjs.CommentsTest do
  use Wsdjs.DataCase, async: true

  alias Wsdjs.Musics.Comment

  @create_attrs %{text: "song title"}

  test "changeset with minimal valid attributes" do
    changeset = Comment.changeset(%Comment{}, @create_attrs)
    assert changeset.valid?
  end

  test "comment user and song must exist" do
    params = Map.put(@create_attrs, :user_id, Ecto.UUID.generate())
    params = Map.put(params, :song_id, Ecto.UUID.generate())
    comment = Comment.changeset(%Comment{}, params)
    assert {:error, %{errors: [user: {"does not exist", _}]}} = Repo.insert(comment)
  end

  test "song comment length > 0" do
    comment = Comment.changeset(%Comment{}, %{text: ""})
    assert {:error, %{errors: [text: {"can't be blank", _}]}} = Repo.insert(comment)
  end
end
