defmodule WsdjsWeb.Admin.InvitationController do
  @moduledoc """
  This 
  """
  use WsdjsWeb, :controller

  alias Wsdjs.Auth
  alias WsdjsWeb.{InvitationEmail, Mailer}

  def update(conn, %{"id" => id}) do
    with invitation <- Auth.get_invitation!(id),
         {:ok, invitation} <- Auth.accept_invitation(invitation) do
      # mailing is not in the with because it's not a blocking
      invitation
      |> InvitationEmail.invitation_accepted()
      |> Mailer.deliver_later()

      conn
      |> put_flash(
        :info,
        "Invitation #{invitation.name} accepted successfully. You can now delete the invitation (invitations are deprecated)"
      )
      |> redirect(to: user_path(conn, :show, invitation.user_id))
    end
  end

  def delete(conn, %{"id" => id}) do
    invitation = Auth.get_invitation!(id)
    {:ok, _} = Auth.delete_invitation(invitation)

    conn
    |> put_flash(:info, "Invitation deleted successfully.")
    |> redirect(to: admin_user_path(conn, :index))
  end
end
