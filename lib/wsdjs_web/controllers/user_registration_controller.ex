defmodule WsdjsWeb.UserRegistrationController do
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User
  alias WsdjsWeb.UserAuth

  plug :put_root_layout, {WsdjsWeb.LayoutView, :root_auth}

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp create_with_profil(conn, user_params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:user, Accounts.register_user(account, params))
    |> Ecto.Multi.insert(:user_profil, Accounts.create_profil_for_user(user))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end
end
