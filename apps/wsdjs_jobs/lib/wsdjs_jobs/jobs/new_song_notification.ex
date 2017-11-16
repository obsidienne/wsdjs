defmodule Wsdjs.Jobs.NewSongNotification do
  import Bamboo.Email

  @html_mail_template Path.expand("./lib/wsdjs_jobs/priv/static/email/new_song_notification.html.eex")
  @text_mail_template Path.expand("./lib/wsdjs_jobs/priv/static/email/new_song_notification.text.eex")

  def call(_args \\ []) do
    users = Wsdjs.Accounts.list_users_to_notify("new song")

    if Enum.count(users) > 0 do
      new_email()
      |> bcc(users)
      |> from("no-reply@wsdjs.com")
      |> subject("New songs suggested")
      |> html_body(EEx.eval_file(@html_mail_template))
      |> text_body(EEx.eval_file(@text_mail_template))
      |> Wsdjs.Jobs.Mailer.deliver_later
    end
  end
end
