defmodule Wsdjs.Web.TopView do
  use Wsdjs.Web, :view

  def current_user_vote(top, rank) do
    current_user_vote = Enum.find(top.votes, fn(x) -> x.song_id == rank.song.id  end)

    if is_nil(current_user_vote) do
      nil
    else
      current_user_vote.votes
    end
  end
end
