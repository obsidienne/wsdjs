defmodule Wsdjs.Jobs.NewSongNotification do
  import Bamboo.Email
  use Bamboo.Phoenix, view: Wsdjs.Jobs.EmailView

  def call(_args \\ []) do
    IO.puts "send email"

    users = Wsdjs.Accounts.list_users(new_song_notification: true)
    songs = Wsdjs.Musics.list_songs()

    new_email()
    |> bcc(users)
    |> from("no-reply@wsdjs.com")
    |> subject("New songs suggested")
    |> render(:new_song_notification)
    |> Wsdjs.Jobs.Mailer.deliver_later
  end
end
