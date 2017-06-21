defmodule Wsdjs.Web.AuthenticationEmail do
  use Bamboo.Phoenix, view: Wsdjs.Web.EmailView

  import Bamboo.Email

  @doc """
    The sign in email containing the login link.
  """
  def login_link(token_value, user) do
    new_email()
    |> to(user.email)
    |> from("info@myapp.com")
    |> subject("Sign in to World Swing Deejays")
    |> assign(:token, token_value)
    |> render(:login_link)
  end
end
