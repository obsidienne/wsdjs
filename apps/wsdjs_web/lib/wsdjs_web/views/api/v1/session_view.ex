defmodule WsdjsWeb.Api.V1.SessionView do
  use WsdjsWeb, :view

  alias WsdjsWeb.CloudinaryHelper

  def render("show.json", %{user: user, avatar: avatar, bearer: bearer}) do
    %{
      id: user.id,
      email: user.email,
      dj_name: user.djname,
      path: user_path(WsdjsWeb.Endpoint, :show, user),
      avatars: %{
        avatar_uri_200: CloudinaryHelper.avatar_url_with_resolution(avatar, 200),
        avatar_uri: CloudinaryHelper.avatar_url(avatar)
      },
      auth: %{
        bearer: bearer,
        expired_at: Timex.to_unix(Timex.shift(Timex.now, seconds: 1_209_600))
      }
    }
  end
end
