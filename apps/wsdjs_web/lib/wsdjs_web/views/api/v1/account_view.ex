defmodule WsdjsWeb.Api.V1.AccountView do
    use WsdjsWeb, :view
  
    alias WsdjsWeb.CloudinaryHelper
  
    def render("show.json", %{user: user, avatar: avatar}) do
      %{
        id: user.id,
        admin: user.admin,
        email: user.email,
        name: user.name,
        country: user.user_country,
        djname: user.djname,
        profil_dj: user.profil_dj,
        details: %{
            description: user.detail.description,
            favorite_genre: user.detail.favorite_genre,
            favorite_artist: user.detail.favorite_artist,
            favorite_color: user.detail.favorite_color,
            favorite_meal: user.detail.favorite_meal,
            favorite_animal: user.detail.favorite_animal,
            djing_start_year: user.detail.djing_start_year,
            love_more: user.detail.love_more,
            hate_more: user.detail.hate_more,
            youtube: user.detail.youtube,
            facebook: user.detail.facebook,
            soundcloud: user.detail.soundcloud,
        },
        avatar: %{
            avatar_uri_200: CloudinaryHelper.avatar_url_with_resolution(avatar, 200),
            avatar_uri: CloudinaryHelper.avatar_url(avatar)
        }
      }
    end

    def render("update.json", %{user: user, avatar: avatar}) do
       %{
        test: "ok"
       } 
        
    end
  end
  