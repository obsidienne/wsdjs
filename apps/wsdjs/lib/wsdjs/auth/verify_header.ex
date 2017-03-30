defmodule Wsdjs.VerifyHeader do
  import Plug.Conn

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, _opts) do
    token = fetch_token(get_req_header(conn, "authorization"))
    case verify_token(conn, token) do
      {:ok, payload} ->
        user = if payload, do: Wcsp.Accounts.find_user!(id: payload)
        assign(conn, :current_user, user)
      {:error, _} ->
        conn
    end
  end

  defp fetch_token([]), do: nil
  defp fetch_token([token|_tail]) do
    token
    |> String.replace("Bearer ", "")
    |> String.trim
  end

  defp verify_token(conn, token) do
    Phoenix.Token.verify(conn, "user", token, max_age: 1_209_600)
  end

end
