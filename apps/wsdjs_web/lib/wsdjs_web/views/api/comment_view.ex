defmodule WsdjsWeb.Api.CommentView do
  use WsdjsWeb, :view

  alias WsdjsWeb.Api.CommentView
  alias WsdjsWeb.Api.WebRouteHelpers

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

  # 1506925999
  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      text: comment.text,
      text_html: comment.text_html,
      user: %{
        name: comment.user.name,
        dj_name: comment.user.djname,
        id: comment.user.id,
        path: WebRouteHelpers.user_path(WsdjsApi.Endpoint, :show, comment.user),
        avatars: %{
          avatar_uri_200: Attachments.avatar_url(comment.user.avatar, 200),
          avatar_uri: Attachments.avatar_url(comment.user.avatar, 100)
        }
      },
      commented_at: DateTime.to_iso8601(DateTime.from_naive!(comment.inserted_at, "Etc/UTC")),
      timestamp: Timex.to_unix(comment.inserted_at)
    }
  end
end
