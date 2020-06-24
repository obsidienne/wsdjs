defmodule WsdjsWeb.Api.AccountView do
  use WsdjsWeb, :view

  def render("show.json", %{user: user}) do
    %{
      data: user |> profil() |> add_avatar(user.avatar) |> add_details(user.profil)
    }
  end

  defp profil(user) do
    %{
      id: user.id,
      admin: user.admin,
      email: user.email,
      name: user.name,
      country: user.user_country,
      djname: user.djname,
      profil_dj: user.profil_dj,
      verified_profil: user.verified_profil
    }
  end

  defp add_avatar(user, nil), do: user

  defp add_avatar(user, avatar) do
    avatars = %{
      avatar_uri_200: Attachments.avatar_url(avatar, 200),
      avatar_uri: Attachments.avatar_url(avatar, 100)
    }

    Map.put(user, :avatar, avatars)
  end

  defp add_details(user, nil), do: user

  defp add_details(user, detail) do
    profil = %{
      description: detail.description,
      favorite_genre: detail.favorite_genre,
      favorite_artist: detail.favorite_artist,
      djing_start_year: detail.djing_start_year,
      youtube: detail.youtube,
      facebook: detail.facebook,
      soundcloud: detail.soundcloud
    }

    Map.put(user, :profil, profil)
  end
end
