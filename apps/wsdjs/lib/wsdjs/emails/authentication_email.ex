defmodule Wsdjs.AuthenticationEmail do
  use Bamboo.Phoenix, view: Wsdjs.EmailView

  import Bamboo.Email

  @doc """
    The sign in email containing the login link.
  """
  def login_link(token_value, user) do
    new_email()
    |> to(user.email)
    |> from("info@myapp.com")
    |> subject("Your login link")
    |> assign(:token, token_value)
    |> render("login_link.text")
  end
end
