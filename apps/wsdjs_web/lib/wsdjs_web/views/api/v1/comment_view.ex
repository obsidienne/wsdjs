defmodule Wsdjs.Web.Api.V1.CommentView do
  use Wsdjs.Web, :view

  alias Wsdjs.Web.Api.V1.CommentView
  alias Wsdjs.Web.CloudinaryHelper

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      text: comment.text,
      commented_by_path: user_path(Wsdjs.Web.Endpoint, :show, comment.user),
      commented_by: comment.user.name,
      commented_by_avatar: CloudinaryHelper.avatar_url(comment.user.avatar),
      commented_at: DateTime.to_iso8601(DateTime.from_naive!(comment.inserted_at, "Etc/UTC"))
      }
  end
end
