defmodule WsdjsApi.WebRouteHelpers do
  @doc ~S"""
  ## Examples

      iex> WsdjsApi.WebRouteHelpers.user_path("conn", :show, %{id: 42})
      "http://web:4000/users/42"
  """
  def user_path(_, :show, %{id: id}) do
    base_url = Application.get_env(:wsdjs_api, __MODULE__) |> Keyword.get(:base_url)
    base_url <> "/users/#{id}"
  end

  @doc ~S"""
  ## Examples

      iex> WsdjsApi.WebRouteHelpers.song_path("conn", :show, %{id: 42})
      "http://web:4000/songs/42"
  """
  def song_path(_, :show, %{id: id}) do
    base_url = Application.get_env(:wsdjs_api, __MODULE__) |> Keyword.get(:base_url)
    base_url <> "/songs/#{id}"
  end
end
