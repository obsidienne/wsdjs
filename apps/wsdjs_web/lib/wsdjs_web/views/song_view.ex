defmodule Wsdjs.Web.SongView do
  use Wsdjs.Web, :view

  alias Wsdjs.Accounts

  def list_users do
    users = Accounts.list_users()
    Enum.map(users, &{user_displayed_name(&1), &1.id})
  end

  def song_full_description(song) do
    date_str = utc_to_local(song.inserted_at)

    bpm_str = case song.bpm do
      0 -> "-"
      _ -> "- #{song.bpm} bpm -"
    end

    "#{song.artist} - #{song.genre} #{bpm_str} suggested by #{song.user.name} #{date_str}"
  end
end
