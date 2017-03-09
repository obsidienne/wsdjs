defmodule Wsdjs.TopView do
  use Wsdjs, :view


  def voting_label(top, rank) do
    current_user_vote = Enum.find(top.rank_songs, fn(x) -> x.song_id == rank.song.id  end)

    content_tag(:label, for: "song-#{rank.id}") do
      [
        tag(:img, width: "60", height: "60", src: song_art_href(rank.song.album_art)),
        content_tag(:div, class: "voting-position charted") do
          voting_show(current_user_vote)
        end
      ]
    end
  end

  defp voting_show(nil), do: ""
  defp voting_show(current_user_vote), do: {:safe, [~s(<div class="chart-bg"></div>), ~s(<div class="chart-value">#{current_user_vote.votes}</div>)]}

  def voting_checkbox(f, top, rank) do
    current_user_vote = Enum.find(top.rank_songs, fn(x) -> x.song_id == rank.song.id  end)
    do_voting_checkbox(f, rank, current_user_vote)
  end

  defp do_voting_checkbox(f, rank, nil) do
    checkbox f, :vote, name: "votes[#{rank.song.id}]", unchecked_value: 0, id: "song-#{rank.id}", class: "hidden"
  end

  defp do_voting_checkbox(f, rank, current_user_vote) do
    checkbox f, :vote, name: "votes[#{rank.song.id}]", unchecked_value: 0, id: "song-#{rank.id}", class: "hidden", checked_value: current_user_vote.votes, checked: true
  end
end
