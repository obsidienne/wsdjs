defmodule WsdjsWeb.InvitationController do
  @moduledoc false

  use WsdjsWeb, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.Invitation

  action_fallback WsdjsWeb.FallbackController

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
      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, "Invitation already requested.")
        |> redirect(to: session_path(conn, :new))
    end
  end
end

