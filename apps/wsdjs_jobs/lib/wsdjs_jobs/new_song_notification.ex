defmodule Wsdjs.Jobs.NewSongNotification do
  def call(args \\ []) do
    IO.puts "send email"

    users = Wsdjs.Accounts.list_users(new_song_notification: true)
    songs = Wsdjs.Musics.list_songs()
  end
end
