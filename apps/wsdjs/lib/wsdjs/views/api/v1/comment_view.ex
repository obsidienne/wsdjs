defmodule Wsdjs.API.V1.CommentView do
  use Wsdjs, :view

  alias Wsdjs.CommentView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      artist: comment.artist,
      title: comment.title,
      bpm: comment.bpm}
  end
end
