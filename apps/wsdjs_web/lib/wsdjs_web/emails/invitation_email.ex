defmodule WsdjsWeb.InvitationEmail do
    @moduledoc false
    use Bamboo.Phoenix, view: WsdjsWeb.EmailView

    import Bamboo.Email

    @doc """
    The request for invitation registration email.
    """
    def invitation_registered(user) do
      datetime = Timex.now

      new_email()
      |> to(user.email)
      |> from("no-reply@worldswingdjs.com")
      |> subject("Worldswingdjs : Invitation registered")
      |> render(:invitation_registered, invitation: user)
    end
  end
