defmodule Wsdjs.Web.TopView do
  use Wsdjs.Web, :view

  def voting_show(top, rank) do
    current_user_vote = Enum.find(top.votes, fn(x) -> x.song_id == rank.song.id  end)
    voting_show(current_user_vote)
  end

  defp voting_show(nil), do: ""
  defp voting_show(current_user_vote), do: {:safe, [~s(<div class="chart-bg"></div>), ~s(<div class="chart-value">#{current_user_vote.votes}</div>)]}

  def voting_checkbox(f, top, rank) do
    current_user_vote = Enum.find(top.votes, fn(x) -> x.song_id == rank.song.id  end)
    do_voting_checkbox(f, rank, current_user_vote)
  end

  defp do_voting_checkbox(f, rank, nil) do
    checkbox f, :vote, name: "votes[#{rank.song.id}]", unchecked_value: 0, id: "song-#{rank.id}", class: "hidden"
  end

  defp do_voting_checkbox(f, rank, current_user_vote) do
    checkbox f, :vote, name: "votes[#{rank.song.id}]", unchecked_value: 0, id: "song-#{rank.id}", class: "hidden", checked_value: current_user_vote.votes, checked: true
  end

  def suggestor_name(%Wsdjs.Accounts.User{name: _, djname: djname}) when is_binary(djname), do: djname
  def suggestor_name(%Wsdjs.Accounts.User{name: name}) when is_binary(name), do: name
end
