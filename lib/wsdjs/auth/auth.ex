defmodule Wsdjs.Auth do
  @moduledoc """
  The boundary for the Authentification system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Repo

  ###############################################
  #
  # Authentification
  #
  ###############################################
  alias Wsdjs.Accounts.User
  alias Wsdjs.Auth.AuthToken

  @token_max_age 1_800
  def get_magic_link_token(value) do
    AuthToken
    |> where([t], t.value == ^value)
    |> where(
      [t],
      t.inserted_at > datetime_add(^NaiveDateTime.utc_now(), ^(@token_max_age * -1), "second")
    )
    |> Repo.one()
    |> Repo.preload(:user)
  end

  def set_magic_link_token(%User{} = user, token) do
    %AuthToken{}
    |> AuthToken.changeset(%{value: token, user_id: user.id})
    |> Repo.insert!()
  end

  def delete_magic_link_token!(token) do
    Repo.delete!(token)
  end

  def first_auth(%User{confirmed_at: nil} = user) do
    query = from(User, where: [id: ^user.id])
    Repo.update_all(query, set: [confirmed_at: Timex.now()])

    {:ok, user}
  end

  def first_auth(%User{} = user), do: {:ok, user}
end
