defmodule Wsdjs.ReactionsTest do
  use Wsdjs.DataCase
  alias Wsdjs.Reactions

  describe "comments" do
    def comment_fixture() do
      {:ok, user} =
        Wsdjs.Accounts.create_user(%{email: "dummy#{System.unique_integer()}@bshit.com"})

      {:ok, song} =
        Wsdjs.Musics.create_song(%{
          title: "my title#{System.unique_integer()}",
          artist: "my artist",
          genre: "soul",
          url: "http://youtu.be/dummy",
          user_id: user.id
        })

      {:ok, comment} =
        Reactions.create_comment(%{text: "mega song", user_id: user.id, song_id: song.id})

      comment
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Reactions.get_comment!(comment.id) |> Wsdjs.Repo.preload(user: :avatar) == comment
    end

    test "list_comments/1 returns all song comments" do
      comment = comment_fixture()
      _dummy = comment_fixture()
      song = Wsdjs.Musics.get_song!(comment.song_id)
      assert Reactions.list_comments(song) == [comment]
    end
  end
end
