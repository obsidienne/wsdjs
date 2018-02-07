defmodule WsdjsWeb.MagicLink do
  @moduledoc """
    Service with functions for creating and signing in with magic link tokens.
  """
  alias WsdjsWeb.{Endpoint, Mailer, AuthenticationEmail}
  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User
  alias Wsdjs.Auth
  alias Phoenix.Token

  #  Token is valid for 30 minutes.
  @token_max_age 1_800

  @doc """
    Creates and sends a new magic login token to the user or email.
  """
  def provide_token(nil, _), do: {:error, :not_found}

  @doc """
  Provide an auth token for a user. The case are as following:
    - existing activated user => send a token
    - non existing user => create the user and send a token
    - existing user but desactivated => do not send the token
  """
  def provide_token(email, device) when is_binary(email) and device in ["api", "browser"] do
    user =
      case Accounts.get_user_by_email(email) do
        %User{deactivated: false} = user ->
          user

        nil ->
          {:ok, %User{} = user} = Accounts.create_user(%{email: email})
          user

        _ ->
          nil
      end

    send_token(user, device)
  end

  # User could not be found by email.
  defp send_token(nil, _), do: {:error, :not_found}

  # Creates a token and sends it to the user.
  defp send_token(%User{} = user, "browser") do
    user
    |> create_token()
    |> AuthenticationEmail.browser_login(user)
    |> Mailer.deliver_now()

    {:ok, user}
  end

  # Creates a token and sends it to the user.
  defp send_token(%User{} = user, "api") do
    user
    |> create_token()
    |> AuthenticationEmail.api_login(user)
    |> Mailer.deliver_now()

    {:ok, user}
  end

  # Creates a new token, store it in the DB for the given user and returns the token value.
  defp create_token(%User{} = user) do
    auth_token = Phoenix.Token.sign(Endpoint, "signin", user.id)
    Auth.set_magic_link_token(user, auth_token)
    auth_token
  end

  @doc """
    Checks the given token.
  """
  def verify_magic_link(value) do
    value
    |> Auth.get_magic_link_token()
    |> verify_token()
  end

  # Unexpired token could not be found.
  defp verify_token(nil), do: {:error, :invalid}

  # Loads the user and deletes the token as it can only be used once.
  defp verify_token(token) do
    %Auth.AuthToken{} = Auth.delete_magic_link_token!(token)

    %User{id: user_id} = token.user

    # verify the token matching the user id
    case Token.verify(Endpoint, "signin", token.value, max_age: @token_max_age) do
      {:ok, ^user_id} ->
        {:ok, token.user}

      # reason can be :invalid or :expired
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Checks the given token.
  """
  alias Wsdjs.Accounts.User

  @invited_max_age 86_400
  def verify_invited_link(value) do
    case Phoenix.Token.verify(Endpoint, "invited", value, max_age: @invited_max_age) do
      {:ok, user_id} ->
        user = Accounts.get_user!(user_id)
        {:ok, user}

      # reason can be :invalid or :expired
      {:error, reason} ->
        {:error, reason}
    end
  end

  def provide_invitation_accepted_token(%User{} = user) do
    Phoenix.Token.sign(Endpoint, "invited", user.id)
  end
end
