defmodule WsdjsWeb.SongView do
  use WsdjsWeb, :view

  alias Wsdjs.Accounts

  def list_users do
    users = Accounts.list_users()
    Enum.map(users, &{user_displayed_name(&1), &1.id})
  end

  def song_full_description(song) do
    date_str = song.inserted_at
    |> Timex.to_date()
    |> Timex.format!("%d %b %Y", :strftime)

    
    bpm_str = case song.bpm do
      0 -> "-"
      _ -> "- #{song.bpm} bpm -"
    end

    "#{song.artist} - #{song.genre} #{bpm_str} suggested by #{song.user.name} - #{date_str}"
  end
end
