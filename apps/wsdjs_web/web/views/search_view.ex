defmodule WsdjsWeb.SearchView do
  use WsdjsWeb.Web, :view

  @base_url "http://res.cloudinary.com/don2kwaju/image/upload/"
  @small_format "ar_1:1,c_fill,g_auto/w_auto:100:250/dpr_auto/f_auto,q_auto/"
  @missing_song_art "v1/wsdjs/missing_cover.jpg"


  def proposed_by_avatar(%Wcsp.Avatar{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url <> @small_format <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def proposed_by_avatar(_), do: @base_url <> @small_format <> @missing_song_art

  def proposed_by_display_name(%Wcsp.User{djname: djname}) when is_binary(djname), do: djname
  def proposed_by_display_name(%Wcsp.User{name: name}), do: name

  def proposed_date(dt), do: Ecto.DateTime.to_iso8601(Ecto.DateTime.cast!(dt))
end
