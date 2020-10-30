defmodule WsdjsWeb.UserHelper do
  @moduledoc """
  This modules contains all helpers for a %User{}.
  """
  import WsdjsWeb.Router.Helpers
  alias Wsdjs.Accounts.User

  def user_displayed_name(%User{email: email}), do: email

  def proposed_by_link(conn, %Wsdjs.Songs.Song{} = song) do
    Phoenix.HTML.Link.link(
      user_displayed_name(song.user),
      to: user_path(conn, :show, song.user.id),
      title:
        "suggested by #{song.user.name}, #{
          Timex.format!(song.inserted_at, "%b %d, %Y", :strftime)
        }"
    )
  end
end
