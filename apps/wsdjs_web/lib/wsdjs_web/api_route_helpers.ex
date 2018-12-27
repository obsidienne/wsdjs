defmodule WsdjsWeb.ApiRouteHelpers do
  def opinion_path(_, :show, %{id: id}) do
    base_url = Application.get_env(:wsdjs_web, __MODULE__) |> Keyword.get(:base_url)
    base_url <> "/users/#{id}"
  end

  def opinion_path(_, :delete, %{id: id}) do
    base_url = Application.get_env(:wsdjs_web, __MODULE__) |> Keyword.get(:base_url)
    base_url <> "/opinions/#{id}"
  end

  def comment_path(_, :delete, %{id: id}) do
    base_url = Application.get_env(:wsdjs_web, __MODULE__) |> Keyword.get(:base_url)
    base_url <> "/comments/#{id}"
  end

  def song_comment_path(_, :create, %{id: id}) do
    base_url = Application.get_env(:wsdjs_web, __MODULE__) |> Keyword.get(:base_url)
    base_url <> "/comments/#{id}"
  end

  def song_opinion_path(_, :create, %{id: id}, kind: _kind) do
    base_url = Application.get_env(:wsdjs_web, __MODULE__) |> Keyword.get(:base_url)
    base_url <> "/comments/#{id}"
  end

  def video_path(_, :delete, %{id: id}) do
    base_url = Application.get_env(:wsdjs_web, __MODULE__) |> Keyword.get(:base_url)
    base_url <> "/comments/#{id}"
  end

  def signin_url(_, :show, token) do
    base_url = Application.get_env(:wsdjs_web, __MODULE__) |> Keyword.get(:base_url)
    base_url <> "/comments/#{token}"
  end

  def song_video_path(_, :create, %{id: id}) do
    base_url = Application.get_env(:wsdjs_web, __MODULE__) |> Keyword.get(:base_url)
    base_url <> "/comments/#{id}"
  end
end
