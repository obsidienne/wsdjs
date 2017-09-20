defmodule WsdjsWeb.InvitationController do
  @moduledoc false

  use WsdjsWeb, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.Invitation
  alias WsdjsWeb.{InvitationEmail, Mailer}

  def new(conn, _params) do
    changeset = Accounts.change_invitation(%Invitation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"invitation" => params}) do
    case Accounts.create_invitation(params) do
      {:ok, invitation} ->
        invitation
        |> InvitationEmail.invitation_registered()
        |> Mailer.deliver_later()

        conn
        |> put_flash(:info, "Your request has been sent to our administrator who will reply soon.")
        |> redirect(to: session_path(conn, :new))
      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:error, "Invitation already requested.")
        |> redirect(to: session_path(conn, :new))
    end
  end
end
