defmodule Wsdjs.UserHelper do
  @base_url "http://res.cloudinary.com/don2kwaju/image/upload/"
  @small "w_auto/c_scale/"
  @missing_avatar "v1/wsdjs/missing_cover.jpg"

  def avatar_href(%Wcsp.Avatar{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url <> @small <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def avatar_href_default(), do: @base_url <> @small <> @missing_avatar
  def avatar_href(_), do: @base_url <> @small <> @missing_avatar

  def proposed_by_display_name(%Wcsp.User{name: name, djname: djname}) when is_binary(djname), do: "#{name} (#{djname})"
  def proposed_by_display_name(%Wcsp.User{name: name}), do: name

  def user_avatar_alt(user), do: "#{user.name}"
end
