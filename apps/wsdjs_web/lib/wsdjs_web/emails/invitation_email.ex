defmodule WsdjsWeb.InvitationEmail do
  @moduledoc false
  use Bamboo.Phoenix, view: WsdjsWeb.EmailView

  import Bamboo.Email

  @doc """
  The request for invitation registration email.
  """
  def invitation_registered(user) do
    new_email()
    |> to(user.email)
    |> from("no-reply@worldswingdjs.com")
    |> subject("Worldswingdjs : Invitation registered")
    |> render(:invitation_registered, invitation: user)
  end

  def invitation_accepted(user) do
    new_email()
    |> to(user.email)
    |> from("no-reply@worldswingdjs.com")
    |> subject("Worldswingdjs : Invitation accepted")
    |> render(:invitation_accepted, invitation: user)
  end
end
