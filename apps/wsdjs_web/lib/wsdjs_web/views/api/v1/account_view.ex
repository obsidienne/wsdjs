defmodule WsdjsWeb.Api.V1.AccountView do
  use WsdjsWeb, :view

  alias WsdjsWeb.CloudinaryHelper

  def render("show.json", %{user: user}) do
    user = %{
      data: %{
        id: user.id,
        admin: user.admin,
        email: user.email,
        name: user.name,
        country: user.user_country,
        djname: user.djname,
        profil_dj: user.profil_dj,
      }
    }
    |> add_details(user.detail)
    |> add_avatar(user.avatar)
  end

  defp add_avatar(user, nil), do: user
  defp add_avatar(user, avatar) do
    avatars = %{
      avatar_uri_200: CloudinaryHelper.avatar_url_with_resolution(avatar, 200),
      avatar_uri: CloudinaryHelper.avatar_url(avatar)
    }

    Map.put(user, :avatar, avatars)
  end

  defp add_details(user, nil), do: user
  defp add_details(user, detail) do
    details = %{
      description: detail.description,
      favorite_genre: detail.favorite_genre,
      favorite_artist: detail.favorite_artist,
      favorite_color: detail.favorite_color,
      favorite_meal: detail.favorite_meal,
      favorite_animal: detail.favorite_animal,
      djing_start_year: detail.djing_start_year,
      love_more: detail.love_more,
      hate_more: detail.hate_more,
      youtube: detail.youtube,
      facebook: detail.facebook,
      soundcloud: detail.soundcloud
    }

    Map.put(user, :detail, details)
  end
end
