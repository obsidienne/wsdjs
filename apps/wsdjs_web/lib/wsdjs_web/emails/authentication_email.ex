defmodule Wsdjs.Web.AuthenticationEmail do
  use Bamboo.Phoenix, view: Wsdjs.Web.EmailView

  import Bamboo.Email

  @doc """
    The sign in email containing the login link.
  """
  def login_link(token_value, user) do
    datetime = Timex.now

    new_email()
    |> to(user.email)
    |> from("no-reply@worldswingdjs.com")
    |> subject("Sign in to World Swing Deejays, sent at #{Timex.format!(datetime, "%l:%M %P", :strftime)} ")
    |> assign(:token, token_value)
    |> render(:login_link)
  end
end
