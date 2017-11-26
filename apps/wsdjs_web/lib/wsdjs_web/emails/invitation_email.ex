defmodule WsdjsWeb.InvitationEmail do
  @moduledoc false
  use Bamboo.Phoenix, view: WsdjsWeb.EmailView

  import Bamboo.Email
  alias Wsdjs.Auth.Invitation

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

  def invitation_accepted(%Invitation{} = invitation) do
    user = Wsdjs.Accounts.get_user!(invitation.user_id)
    token = WsdjsWeb.MagicLink.provide_invitation_accepted_token(user)

    new_email()
    |> to(user.email)
    |> from("no-reply@worldswingdjs.com")
    |> subject("Worldswingdjs : Invitation accepted")
    |> render(:invitation_accepted, invitation: user, token: token)
  end
end
