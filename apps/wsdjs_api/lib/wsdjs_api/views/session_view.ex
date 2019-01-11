defmodule WsdjsApi.SessionView do
  use WsdjsApi, :view
  alias WsdjsApi.WebRouteHelpers

  def render("show.json", %{user: user, avatar: avatar, bearer: bearer}) do
    %{
      id: user.id,
      email: user.email,
      dj_name: user.djname,
      path: WebRouteHelpers.user_path(WsdjsApi.Endpoint, :show, user),
      avatars: %{
        avatar_uri_200: Attachments.avatar_url(avatar, 200),
        avatar_uri: Attachments.avatar_url(avatar, 100)
      },
      auth: %{
        bearer: bearer,
        expired_at: Timex.to_unix(Timex.shift(Timex.now(), seconds: 1_209_600))
      }
    }
  end
end
