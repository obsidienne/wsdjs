defmodule WsdjsWeb.SuggestionController do
  @moduledoc false

  use WsdjsWeb, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Reactions
  alias Wsdjs.Reactions.Comment
  alias Wsdjs.Musics.Song
  alias Wsdjs.Attachments
  alias Wsdjs.Attachments.Video

  action_fallback WsdjsWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user]]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, current_user) do
    with :ok <- Wsdjs.Musics.Policy.can?(current_user, :suggest_song) do
      changeset = Musics.change_song(%Song{})
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"song" => params}, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    with :ok <- Wsdjs.Musics.Policy.can?(current_user, :suggest_song),
          {:ok, song} <- Musics.create_suggestion(params) do
      conn
      |> put_flash(:info, "#{song.title} suggested")
      |> redirect(to: song_path(conn, :show, song.id))
    end
  end
end
