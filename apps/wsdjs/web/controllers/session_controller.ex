defmodule Wsdjs.SessionController do
  use Wsdjs.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email}}) do
    case login_by_email(conn, email, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: hottest_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: session_path(conn, :new))
  end

  defp login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  defp login_by_email(conn, email, _opts) do
    user = if email, do: Wcsp.find_user(email: email)

    cond do
      user ->
        {:ok, login(conn, user)}
      true ->
        {:error, :not_found, conn}
    end
  end
end
