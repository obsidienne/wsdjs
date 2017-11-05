defmodule WsdjsWeb.MagicLink do
  @moduledoc """
    Service with functions for creating and signing in with magic link tokens.
  """
  alias WsdjsWeb.{Endpoint, Mailer, AuthenticationEmail}
  alias Wsdjs.Accounts
  alias Phoenix.Token

  #  Token is valid for 30 minutes.
  @token_max_age 1_800

  @doc """
    Creates and sends a new magic login token to the user or email.
  """
  def provide_token(nil, _), do: {:error, :not_found}

  def provide_token(email, type) when is_binary(email) and type in ["api", "browser"] do
    email
    |> Wsdjs.Accounts.get_user_by_email()
    |> send_token(type)
  end

  # User could not be found by email.
  defp send_token(nil, _), do: {:error, :not_found}

  # Creates a token and sends it to the user.
  defp send_token(user, "browser") do
    user
    |> create_token()
    |> AuthenticationEmail.browser_login(user)
    |> Mailer.deliver_now()

    {:ok, user}
  end

  # Creates a token and sends it to the user.
  defp send_token(user, "api") do
    user
    |> create_token()
    |> AuthenticationEmail.api_login(user)
    |> Mailer.deliver_now()

    {:ok, user}
  end

  # Creates a new token, store it in the DB for the given user and returns the token value.
  defp create_token(user) do
    auth_token = Phoenix.Token.sign(Endpoint, "user", user.id)
    Accounts.set_magic_link_token(user, auth_token)
    auth_token
  end

  @doc """
    Checks the given token.
  """
  def verify_magic_link(value) do
    value
    |> Accounts.get_magic_link_token()
    |> verify_token()
  end

  # Unexpired token could not be found.
  defp verify_token(nil), do: {:error, :invalid}

  # Loads the user and deletes the token as it can only be used once.
  defp verify_token(token) do
    Accounts.delete_magic_link_token!(token)

    user_id = token.user.id

    # verify the token matching the user id
    case Token.verify(Endpoint, "user", token.value, max_age: @token_max_age) do
      {:ok, ^user_id} ->
        {:ok, token.user}

      # reason can be :invalid or :expired
      {:error, reason} ->
        {:error, reason}
    end
  end
end
