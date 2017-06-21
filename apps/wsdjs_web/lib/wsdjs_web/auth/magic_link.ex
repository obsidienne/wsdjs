defmodule Wsdjs.Web.MagicLink do
  @moduledoc """
    Service with functions for creating and signing in with magic link tokens.
  """
  alias Wsdjs.Web.{Endpoint, Mailer, AuthenticationEmail}
  alias Phoenix.Token

  # token is valid for 30 minutes / 1800 seconds
  @token_max_age 1_800

  @doc """
    Creates and sends a new magic login token to the user or email.
  """
  def provide_token(nil), do: {:error, :not_found}

  def provide_token(email) when is_binary(email) do
    Wsdjs.Accounts.get_user_by_email(email)
    |> send_token()
  end

  # User could not be found by email.
  defp send_token(nil), do: {:error, :not_found}

  # Creates a token and sends it to the user.
  defp send_token(user) do
    user
    |> create_token()
    |> AuthenticationEmail.login_link(user)
    |> Mailer.deliver_now()

    {:ok, user}
  end

  # Creates a new token, store it in the DB for the given user and returns the token value.
  defp create_token(user) do
    auth_token = Phoenix.Token.sign(Endpoint, "user", user.id)
    Wsdjs.Accounts.set_magic_link_token(user, auth_token)
    auth_token
  end


  @doc """
    Checks the given token.
  """
  def verify_magic_link(value) do
    Wsdjs.Accounts.get_magic_link_token(value)
    |> verify_token()
  end

  # Unexpired token could not be found.
  defp verify_token(nil), do: {:error, :invalid}

  # Loads the user and deletes the token as it is now used once.
  defp verify_token(token) do
    Wsdjs.Accounts.delete_magic_link_token!(token)

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
