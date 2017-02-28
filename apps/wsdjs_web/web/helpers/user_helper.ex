defmodule WsdjsWeb.UserHelper do
  @base_url "http://res.cloudinary.com/don2kwaju/image/upload/"
  @small "ar_1:1,c_fill,g_auto/w_auto:100:250/dpr_auto/f_auto,q_auto/"
  @round "ar_1:1,c_fill,g_custom,r_max/w_auto:100:100/dpr_auto/f_auto,q_auto/"
  @missing_avatar "v1/wsdjs/missing_cover.jpg"

  def avatar_href(%Wcsp.Avatar{cld_id: cld_id, version: version}, "round") when is_binary(cld_id) do
    @base_url <> @round <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def avatar_href(_, "round"), do: @base_url <> @round <> @missing_avatar

  def avatar_href(%Wcsp.Avatar{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url <> @small <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def avatar_href(_), do: @base_url <> @small <> @missing_avatar




  def proposed_by_display_name(%Wcsp.User{name: name, djname: djname}) when is_binary(djname), do: "#{name} (#{djname})"
  def proposed_by_display_name(%Wcsp.User{name: name}), do: name




  def user_avatar_alt(user), do: "#{user.name}"
end
