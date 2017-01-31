defmodule WsdjsWeb.SearchView do
  use WsdjsWeb.Web, :view

  def href_song_art(%{album_art_cld_id: cld_id, album_art_version: version}) when is_binary(cld_id) do
    "http://res.cloudinary.com/don2kwaju/image/upload/ar_1:1,c_fill,g_auto/w_auto:100:250/dpr_auto/f_auto,q_auto/v#{version}/#{cld_id}.jpg"
  end
  def href_song_art(_), do: "http://res.cloudinary.com/don2kwaju/image/upload/ar_1:1,c_fill,g_auto/w_auto:100:250/dpr_auto/f_auto,q_auto/v1/wsdjs/missing_cover.jpg"

  def song_art_alt(song) do
    "#{song.artist} - #{song.title} song art"
  end

  def proposed_by_avatar(%{avatar_cld_id: cld_id, avatar_version: version}) when is_binary(cld_id) do
    "http://res.cloudinary.com/don2kwaju/image/upload/ar_1:1,c_fill,g_auto/w_auto:100:250/dpr_auto/f_auto,q_auto/v#{version}/#{cld_id}.jpg"
  end
  def proposed_by_avatar(_), do: "http://res.cloudinary.com/don2kwaju/image/upload/ar_1:1,c_fill,g_auto/w_auto:100:250/dpr_auto/f_auto,q_auto/v1/wsdjs/missing_cover.jpg"

  def proposed_by_display_name(%{name: name, djname: djname}) when is_binary(djname), do: djname
  def proposed_by_display_name(%{name: name, djname: djname}), do: name

  def proposed_date(dt), do: Ecto.DateTime.to_iso8601(Ecto.DateTime.cast!(dt))

  def song_id_uuid(id) do
    {:ok, uuid} = Ecto.UUID.load(id)
    uuid
  end
end
