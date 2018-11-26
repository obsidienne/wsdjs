defmodule Wsdjs.Notifications do
  @moduledoc """
  The boundary for the Notification system.
  """
  import Ecto.Query, warn: false
  alias Wsdjs.Repo

  alias Wsdjs.Accounts.User

  @doc """
  Returns the list of users having new_song_notification: true

  ## Examples

      iex> list_users_to_notify(type)
      [%Accounts.User{}, ...]

  """
  def list_users_to_notify("new song") do
    query =
      from(
        u in User,
        join: p in assoc(u, :parameter),
        where:
          u.deactivated == false and p.new_song_notification == true and u.profil_djvip == true and
            u.deactivated == false
      )

    Repo.all(query)
  end

  def list_users_to_notify("radioking unmatch") do
    query =
      from(
        u in User,
        join: p in assoc(u, :parameter),
        where: u.deactivated == false and p.radioking_unmatch == true
      )

    Repo.all(query)
  end
end
