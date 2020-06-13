defmodule WsdjsWeb.ApiRouteHelpers do
  @doc ~S"""
  ## Examples

      iex> WsdjsWeb.ApiRouteHelpers.opinion_path("conn", :delete, %{id: 42})
      "http://api:5000/opinions/42"
  """
  def opinion_path(_, :delete, %{id: id}) do
    "/api/opinions/#{id}"
  end

  @doc ~S"""
  ## Examples

      iex> WsdjsWeb.ApiRouteHelpers.comment_path("conn", :delete, %{id: 42})
      "http://api:5000/comments/42"

      iex> WsdjsWeb.ApiRouteHelpers.comment_path("conn", :delete, 42)
      "http://api:5000/comments/42"
  """
  def comment_path(_, :delete, %{id: id}) do
    "/api/comments/#{id}"
  end

  def comment_path(_, :delete, id) do
    "/api/comments/#{id}"
  end

  @doc ~S"""
  ## Examples

      iex> WsdjsWeb.ApiRouteHelpers.song_comment_path("conn", :create, %{id: 42})
      "http://api:5000/songs/42/comments"
  """
  def song_comment_path(_, :create, %{id: id}) do
    "/api/songs/#{id}/comments"
  end

  @doc ~S"""
  ## Examples

      iex> WsdjsWeb.ApiRouteHelpers.song_opinion_path("conn", :create, %{id: 42}, kind: "up")
      "http://api:5000/songs/42/opinions?kind=up"
  """
  def song_opinion_path(_, :create, %{id: id}, query) when is_list(query) do
    "/api/songs/#{id}/opinions" <>
      case Enum.count(query) do
        0 -> ""
        _ -> "?" <> URI.encode_query(query)
      end
  end

  @doc ~S"""
  ## Examples

      iex> WsdjsWeb.ApiRouteHelpers.video_path("conn", :delete, %{id: 42})
      "http://api:5000/videos/42"

      iex> WsdjsWeb.ApiRouteHelpers.video_path("conn", :delete, 42)
      "http://api:5000/videos/42"
  """
  def video_path(_, :delete, %{id: id}) do
    "/api/videos/#{id}"
  end

  def video_path(_, :delete, id) do
    "/api/videos/#{id}"
  end

  def signin_url(_, :show, token) do
    "/api/signin/#{token}"
  end

  @doc ~S"""
  ## Examples

      iex> WsdjsWeb.ApiRouteHelpers.song_video_path("conn", :create, %{id: 42})
      "http://api:5000/songs/42/videos"
  """
  def song_video_path(_, :create, %{id: id}) do
    "/api/songs/#{id}/videos"
  end
end
