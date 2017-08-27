defmodule WsdjsWeb.TopView do
  use WsdjsWeb, :view

  def current_user_vote(current_user_votes, rank) do
    current_user_vote = Enum.find(current_user_votes, fn(x) -> x.song_id == rank.song.id  end)

    if is_nil(current_user_vote) do
      nil
    else
      current_user_vote.votes
    end
  end

  def count_dj(songs) do
    songs
    |> Enum.map(fn(x) -> x.user_id end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def dominante_genre(songs) do
    songs
    |> Enum.sort(&(&1 <= &2))
    |> Enum.group_by(fn(x) -> x.genre end)
    |> Enum.map(fn({k, v}) -> {k, Enum.count(v)} end)
    |> Enum.sort(fn({_, v1}, {_, v2}) -> v1 >= v2  end)
    |> Enum.take(3)
    |> Enum.map(fn({k, v}) -> {:safe, "<div>#{k} <small>(#{v})</small></div>"} end)
  end

  def all_genre(songs) do
    {:safe, songs
            |> Enum.sort(&(&1 <= &2))
            |> Enum.group_by(fn(x) -> x.genre end)
            |> Enum.map(fn({k, v}) -> {k, Enum.count(v)} end)
            |> Enum.sort(fn({_, v1}, {_, v2}) -> v1 >= v2  end)
            |> Enum.map(fn({k, v}) -> "#{k} <small>(#{v})</small>" end)
            |> Enum.join(", ")
    }
  end


  def get_ranks_according_to_votes(top) do
    top.ranks
  end

  def get_song_by(top, user, position) do
    vote = Enum.find(top.votes, fn vote ->
      vote.votes == position && vote.user_id == user.id
    end)

    if vote do
      song = Enum.find(top.songs, fn song -> song.id == vote.song_id end)
      {:safe, "#{song.artist} <span class='h6 small'>#{song.title}</span>"}
    else
      ""
    end
  end
end
