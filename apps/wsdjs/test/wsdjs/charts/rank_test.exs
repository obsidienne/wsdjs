defmodule Wsdjs.Charts.RankTest do
  use Wsdjs.DataCase, async: true

  alias Wsdjs.Charts.Rank
  alias Wsdjs.Repo

  test "rank song must exist" do
    attrs = rank_fixture_params()

    params = %{top_id: attrs.top_id, song_id: Ecto.UUID.generate()}
    rank = Rank.changeset(%Rank{}, params)
    assert {:error, %{errors: [song: {"does not exist", _}]}} = Repo.insert(rank)
  end

  test "rank top must exist" do
    attrs = rank_fixture_params()

    params = %{top_id: Ecto.UUID.generate(), song_id: attrs.song_id}
    rank = Rank.changeset(%Rank{}, params)
    assert {:error, %{errors: [top: {"does not exist", _}]}} = Repo.insert(rank)
  end

  test "rank/song/top combinaison is unique" do
    changeset = Rank.changeset(%Rank{}, rank_fixture_params(%{rank: 1}))
    Repo.insert(changeset)
    {:error, changeset} = Repo.insert(changeset)
    assert "has already been taken" in errors_on(changeset).song_id
  end

  test "votes/bonus can be equal to zero" do
    changeset = Rank.changeset(%Rank{}, rank_fixture_params(%{votes: 0, bonus: 0}))
    assert changeset.valid?
  end

  defp rank_fixture_params(attrs \\ %{}) do
    {:ok, %Wsdjs.Accounts.User{} = user} = Wsdjs.Accounts.create_user(%{email: "dummy@bshit.com"})

    {:ok, %Wsdjs.Charts.Top{} = top} =
      Wsdjs.Charts.create_top(%{due_date: Timex.now(), user_id: user.id})

    {:ok, %Wsdjs.Musics.Song{} = song} =
      Wsdjs.Musics.create_song(%{
        title: "a",
        artist: "a",
        genre: "soul",
        url: "http://t.a.com",
        user_id: user.id
      })

    attrs
    |> Map.put(:user_id, user.id)
    |> Map.put(:top_id, top.id)
    |> Map.put(:song_id, song.id)
  end
end
