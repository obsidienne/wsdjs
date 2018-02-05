defmodule WsdjsApi.VerifyHeader do
  @moduledoc """
    This modules aims to authenticate the user in case of API call.
    We use the authorization header to retrieve the Bearer and check
    it's validity.
  """
  import Plug.Conn

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, _opts) do
    token = fetch_token(get_req_header(conn, "authorization"))
    case verify_token(conn, token) do
      {:ok, payload} ->
        user = if payload, do: Wsdjs.Accounts.get_activated_user!(payload)
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

  # Following documentation, a token if valid for 2 weeks.
  defp verify_token(conn, token) do
    Phoenix.Token.verify(conn, "user", token, max_age: 1_209_600)
  end

end
