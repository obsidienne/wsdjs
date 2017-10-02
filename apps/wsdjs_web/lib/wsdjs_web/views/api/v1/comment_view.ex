defmodule WsdjsWeb.Api.V1.CommentView do
  use WsdjsWeb, :view

  alias WsdjsWeb.Api.V1.CommentView
  alias WsdjsWeb.CloudinaryHelper

  def render("index.json", %{comments: comments}) do
    %{
      data: render_many(comments, CommentView, "comment.json")
    }
  end

  def render("show.json", %{comment: comment}) do
    %{
      data: render_one(comment, CommentView, "comment.json")
    }
  end

  #1506925999
  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      text: comment.text,
      user: %{
        name: comment.user.name,
        dj_name: comment.user.djname,
        path: user_path(WsdjsWeb.Endpoint, :show, comment.user),
        avatars: %{
          avatar_uri_200: CloudinaryHelper.avatar_url_with_resolution(comment.user.avatar, 200),
          avatar_uri: CloudinaryHelper.avatar_url(comment.user.avatar)          
        }
      },
      commented_at: DateTime.to_iso8601(DateTime.from_naive!(comment.inserted_at, "Etc/UTC")),
      timestamp: Timex.to_unix(comment.inserted_at)
    }
  end
end
