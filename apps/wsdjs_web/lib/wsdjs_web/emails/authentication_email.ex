defmodule WsdjsWeb.AuthenticationEmail do
  @moduledoc false
  use Bamboo.Phoenix, view: WsdjsWeb.EmailView

  import Bamboo.Email

  @doc """
  The sign in email containing the login link.
  """
  def browser_login(token_value, user) do
    datetime = Timex.now()

    new_email()
    |> to(user.email)
    |> from("no-reply@worldswingdjs.com")
    |> subject(
      "Sign in to World Swing Deejays, sent at #{Timex.format!(datetime, "%l:%M %P", :strftime)} "
    )
    |> assign(:token, token_value)
    |> render(:browser_login)
  end

  @doc """
  The sign in email containing the login link.
  """
  def api_login(token_value, user) do
    datetime = Timex.now()

    new_email()
    |> to(user.email)
    |> from("no-reply@worldswingdjs.com")
    |> subject(
      "Sign in to World Swing Deejays, sent at #{Timex.format!(datetime, "%l:%M %P", :strftime)} "
    )
    |> assign(:token, token_value)
    |> render(:api_login)
  end
end
