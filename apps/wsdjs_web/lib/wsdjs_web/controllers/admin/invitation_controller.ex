defmodule WsdjsWeb.Admin.InvitationController do
  @moduledoc """
  This 
  """
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts

  def update(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    with invitation <- Accounts.get_invitation!(id),
         {:ok, invitation} <- Accounts.accept_invitation(invitation) do

      conn
      |> put_flash(:info, "Invitation #{invitation.name} accepted successfully.")
      |> redirect(to: user_path(conn, :show, invitation.user_id))
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    invitation = Accounts.get_invitation!(id)
    {:ok, _} = Accounts.delete_invitation(invitation)

    conn
    |> put_flash(:info, "Invitation deleted successfully.")
    |> redirect(to: admin_user_path(conn, :index))
  end
end
