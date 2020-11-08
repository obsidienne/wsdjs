defmodule Wsdjs.ReactionsTest do
  use Wsdjs.DataCase
  alias Wsdjs.Reactions

  import Wsdjs.AccountsFixtures

  describe "comments" do
    def comment_fixture do
      user = user_fixture()

      {:ok, song} =
        Wsdjs.Songs.create_song(%{
          title: "my title#{System.unique_integer()}",
          artist: "my artist",
          genre: "soul",
          url: "http://youtu.be/dummy",
          user_id: user.id
        })

      {:ok, comment} =
        Reactions.Comments.create(%{text: "mega song", user_id: user.id, song_id: song.id})

      comment |> Repo.forget(:user)
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Reactions.Comments.get!(comment.id) == comment
    end

    test "list_comments/1 returns all song comments" do
      comment = comment_fixture()
      _dummy = comment_fixture()
      song = Wsdjs.Songs.get_song!(comment.song_id)
      assert Wsdjs.Reactions.Comments.list(song) == [comment]
    end
  end
end
