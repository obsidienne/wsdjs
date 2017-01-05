defmodule Wcsp.CommentTest do
  use Wcsp.Case, async: true
  import Wcsp.Factory

  @valid_attrs %{text: "song title"}

  defp errors_on(model, params) do
    model.__struct__.changeset(model, params).errors
  end

  test "changeset with minimal valid attributes" do
    changeset = Comment.changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "comment user and song must exist" do
    params = Map.put(@valid_attrs, :account_id, Ecto.UUID.generate())
    params = Map.put(params, :song_id, Ecto.UUID.generate())
    comment = Comment.changeset(%Comment{}, params)
    assert {:error, %{errors: [account: {"does not exist", _}]}} = Repo.insert(comment)
  end
end
