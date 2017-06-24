defmodule Wsdjs.Web.UserHelper do
  @base_url "//res.cloudinary.com/don2kwaju/image/upload/w_auto/c_crop,g_custom/"
  @missing_avatar "//res.cloudinary.com/don2kwaju/image/upload/v1450094305/wsdjs/missing_avatar.jpg"

  def avatar_href(%Wsdjs.Accounts.Avatar{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def avatar_href(_), do: @missing_avatar
  def avatar_href_default(), do: @missing_avatar

  def proposed_by_display_name(%Wsdjs.Accounts.User{name: name, djname: djname}) when is_binary(djname), do: "#{name} (#{djname})"
  def proposed_by_display_name(%Wsdjs.Accounts.User{name: name}), do: name

  def user_avatar_alt(user), do: "#{user.name}"

  def user_description_available?(user) do
    user.description != nil && String.length(user.description) > 0
  end

   def user_djname_available?(user) do
    user.djname != nil && String.length(user.djname) > 0
  end

  def user_suggested_songs_available?(songs) do
    length(songs) > 0
  end

  def can_edit_page?(user, current_user) do
    current_user == user
  end
end
