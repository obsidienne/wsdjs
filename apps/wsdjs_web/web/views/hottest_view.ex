defmodule WsdjsWeb.HottestView do
  use WsdjsWeb.Web, :view

  @base_url "http://res.cloudinary.com/don2kwaju/image/upload/"
  @small_format "ar_1:1,c_fill,g_auto/w_auto:100:250/dpr_auto/f_auto,q_auto/"
  @missing_song_art "v1/wsdjs/missing_cover.jpg"

  def href_song_art(%{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url <> @small_format <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def href_song_art(_), do: @base_url <> @small_format <> @missing_song_art

  def song_art_alt(song) do
    "#{song.artist} - #{song.title} song art"
  end

  def proposed_by_display_name(%{name: name, djname: djname}) when is_binary(djname) do
    "#{name} (#{djname})"
  end
  def proposed_by_display_name(%{name: name}), do: name


  def proposed_by_link(conn, song = %Wcsp.Song{}) do
    Phoenix.HTML.Link.link(proposed_by_display_name(song.user),
                           to: user_path(conn, :show, song.user.id),
                           title: "#{song.user.name}")
  end

  def group_song_by_month(songs) do
    songs
    |> Enum.group_by(fn (song) -> month_from_date(song.inserted_at) end)
    |> Enum.sort_by(fn ({dt, _}) -> Date.to_erl(dt) end, &>=/2)
  end

  def month_from_date(date) do
    {:ok, month} = Date.new(date.year, date.month, 1)
    month
  end

  def sort_songs(songs) do
    Enum.sort_by(songs, fn (dt) -> Date.to_erl(dt.inserted_at) end, &>=/2)
  end

  def comment_class(song) do
    case Enum.count(song.comments) do
      0 -> "song-comment-empty"
      _ -> "song-comment"
    end
  end
end
