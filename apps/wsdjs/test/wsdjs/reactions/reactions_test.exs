defmodule Wsdjs.ReactionsTest do
  use Wsdjs.DataCase
  import Wsdjs.Factory
  alias Wsdjs.Reactions
  alias Wsdjs.Reactions.{Comment, Opinion}
  alias Wsdjs.Repo

  describe "comments" do
    test "get_comment!/1 returns the comment with given id" do
      comment = insert(:comment)
      assert comment == Reactions.get_comment!(comment.id) |> Repo.preload([:user, song: :user])
    end

    test "list_comments/1 returns all song comments" do
      song = insert(:song)
      comments = insert_list(3, :comment, song: song)
      assert Reactions.list_comments(song) |> Repo.preload(song: :user) |> Enum.sort() == comments |> Repo.preload([user: :avatar]) |> Enum.sort()
    end
  end
end