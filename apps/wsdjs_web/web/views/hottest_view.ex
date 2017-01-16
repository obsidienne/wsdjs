defmodule WsdjsWeb.HottestView do
  use WsdjsWeb.Web, :view

  def href_album_art(%{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    "http://res.cloudinary.com/don2kwaju/image/upload/ar_1:1,c_fill,g_auto/w_auto:100:250/dpr_auto/f_auto,q_auto/v#{version}/#{cld_id}.jpg"
  end
  def href_album_art(_), do: nil
end
