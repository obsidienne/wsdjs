defmodule WsdjsWeb.SongView do
  use WsdjsWeb, :view

  alias Wsdjs.Accounts
  alias Wsdjs.Happenings
  alias Wsdjs.Reactions.Opinions.Opinion

  def current_opinion(_opinions, nil), do: nil

  def current_opinion(opinions, %Accounts.User{} = current_user) do
    Enum.find(opinions, fn x -> x.user_id == current_user.id end)
  end

  def opinion_used(opinions) do
    opinions
    |> Enum.map(fn x -> x.kind end)
    |> Enum.uniq()
  end

  def opinion_id(nil), do: nil
  def opinion_id(%Opinion{id: id}), do: id

  def opinion_kind(nil), do: nil
  def opinion_kind(%Opinion{kind: kind}), do: kind

  def list_users do
    users = Accounts.list_users()
    Enum.map(users, &{user_displayed_name(&1), &1.id})
  end

  def list_events do
    events = Happenings.list_events()
    Enum.map(events, &{&1.name, &1.id})
  end

  def song_full_description(song) do
    date_str =
      song.inserted_at
      |> Timex.to_date()
      |> Timex.format!("%d %b %Y", :strftime)

    bpm_str =
      case song.bpm do
        0 -> "-"
        _ -> "- #{song.bpm} bpm -"
      end

    "#{song.artist} - #{song.genre} #{bpm_str} suggested by #{song.user.name} - #{date_str}"
  end
end
