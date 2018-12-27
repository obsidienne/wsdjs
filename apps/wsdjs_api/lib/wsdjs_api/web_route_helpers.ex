defmodule WsdjsApi.WebRouteHelpers do
  def user_path(_, :show, %{id: id}) do
    base_url = Application.get_env(:web, __MODULE__) |> Keyword.get(:base_url)
    base_url <> "/users/#{id}"
  end

  def song_path(_, :show, %{id: id}) do
    base_url = Application.get_env(:web, __MODULE__) |> Keyword.get(:base_url)
    base_url <> "/songs/#{id}"
  end
end
