defmodule Wsdjs.Attachments.Policy do
  alias Wsdjs.Accounts.User
  alias Wsdjs.Attachments.Videos.Video

  def can?(%User{admin: true}, _, _), do: :ok
  def can?(%User{id: id}, :delete, %Video{user_id: id}), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%User{admin: true}, _), do: :ok
  def can?(%User{parameter: %{video: true}}, :create_video), do: :ok
  def can?(_, _), do: {:error, :unauthorized}
end
