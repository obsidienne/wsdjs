defmodule Wsdjs.Jobs.NewSuggestion do
  import Bamboo.Email
  alias Wsdjs.Musics
  alias Wsdjs.Notifications

  def call(_args \\ []) do
    users = Notifications.list_users_to_notify("new song")

    if Enum.count(users) > 0 and new_songs?() do
      new_email()
      |> bcc(users)
      |> from("no-reply@wsdjs.com")
      |> subject("New songs suggested")
      |> html_body(EEx.eval_file(email_path("html")))
      |> text_body(EEx.eval_file(email_path("txt")))
      |> Wsdjs.Jobs.Mailer.deliver_later()
    end
  end

  defp new_songs? do
    upper = Timex.now()
    lower = Timex.shift(upper, hours: -24)

    Enum.count(Musics.list_songs(lower, upper)) > 0
  end

  defp email_path("html"),
    do:
      Path.join([
        "#{:code.priv_dir(:wsdjs_jobs)}",
        "static",
        "email",
        "new_song_notification.html.eex"
      ])

  defp email_path("txt"),
    do:
      Path.join([
        "#{:code.priv_dir(:wsdjs_jobs)}",
        "static",
        "email",
        "new_song_notification.text.eex"
      ])
end
