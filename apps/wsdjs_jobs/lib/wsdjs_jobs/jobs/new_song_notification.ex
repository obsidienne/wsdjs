defmodule Wsdjs.Jobs.NewSongNotification do
  import Bamboo.Email

  def call(_args \\ []) do
    users = Wsdjs.Accounts.list_users_to_notify("new song")

    base_tpl = Path.join(["#{:code.priv_dir(:wsdjs_jobs)}", "static", "email"])
    html_tpl = Path.join([base_tpl, "radioking_unmatch.html.eex"])
    txt_tpl = Path.join([base_tpl, "radioking_unmatch.html.eex"])

    if Enum.count(users) > 0 do
      new_email()
      |> bcc(users)
      |> from("no-reply@wsdjs.com")
      |> subject("New songs suggested")
      |> html_body(EEx.eval_file(html_tpl))
      |> text_body(EEx.eval_file(txt_tpl))
      |> Wsdjs.Jobs.Mailer.deliver_later
    end
  end
end
