defmodule WsdjsWeb.SessionController do
  use WsdjsWeb.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email}}) do
    case WsdjsWeb.Auth.login_by_email(conn, email, repo: Repo) do
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
    |> WsdjsWeb.Auth.logout()
    |> redirect(to: session_path(conn, :new))
  end
end
