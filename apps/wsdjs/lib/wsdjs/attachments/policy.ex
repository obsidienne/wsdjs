defmodule Wsdjs.Attachments.Policy do
  alias Wsdjs.Accounts.User
  alias Wsdjs.Attachments.Video
  alias Wsdjs.Repo

  def can?(%User{admin: true}, _, _), do: :ok
  def can?(%User{id: id}, :delete, %Video{user_id: id}), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%User{admin: true}, _), do: :ok
  def can?(%User{} = user, :create_video) do
    if user.parameter.video do
      :ok
    else
      {:error, :unauthorized}
    end
  end
  def can?(_, _), do: {:error, :unauthorized}
end
