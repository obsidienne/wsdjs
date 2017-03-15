defmodule Wsdjs.UserHelper do
  @base_url "https://res.cloudinary.com/don2kwaju/image/upload/w_auto/c_scale/"
  @missing_avatar "data:image/gif;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8//PIfwAJeAO9U/c7OgAAAABJRU5ErkJggg=="

  def avatar_href(%Wcsp.Avatar{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def avatar_href_default(), do: @missing_avatar
  def avatar_href(_), do: @missing_avatar

  def proposed_by_display_name(%Wcsp.User{name: name, djname: djname}) when is_binary(djname), do: "#{name} (#{djname})"
  def proposed_by_display_name(%Wcsp.User{name: name}), do: name

  def user_avatar_alt(user), do: "#{user.name}"
end
