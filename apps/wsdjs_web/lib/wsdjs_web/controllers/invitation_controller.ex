defmodule WsdjsWeb.InvitationController do
  @moduledoc false

  use WsdjsWeb, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.Invitation

  action_fallback WsdjsWeb.FallbackController

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]

    with :ok <- Wsdjs.Accounts.Policy.can?(:list_invitations, current_user) do
      current_user = conn.assigns[:current_user]
      invitations = Accounts.list_invitations(current_user)
      render(conn, "index.html", invitations: invitations)
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_invitation(%Invitation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"invitation" => params}) do
    case Accounts.create_invitation(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Invitation requested.")
        |> redirect(to: home_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Invitation already requested.")
        |> redirect(to: session_path(conn, :new))
    end
  end
end

