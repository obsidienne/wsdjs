defmodule WsdjsJobs.UnmatchSong do
  import Bamboo.Email
  alias Wsdjs.Accounts

  def notify(%{nomatch: true} = song) do
    IO.puts("queue unmatched #{song["artist"]} #{song["title"]} ")

    tpl =
      Path.join([
        "#{:code.priv_dir(:wsdjs_jobs)}",
        "static",
        "email",
        "radioking_unmatch.html.eex"
      ])

    users = Accounts.list_users_to_notify("radioking unmatch")

    if Enum.count(users) > 0 do
      new_email()
      |> to(users)
      |> from("no-reply@wsdjs.com")
      |> subject("Radioking unmatch")
      |> html_body(EEx.eval_file(tpl, song: song))
      |> WsdjsJobs.Mailer.deliver_later()
    end
  end

  def notify(song) do
    IO.puts("queue #{song["artist"]} #{song["title"]} ")
  end
end
