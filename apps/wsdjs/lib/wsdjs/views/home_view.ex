defmodule Wsdjs.HomeView do
  use Wsdjs, :view

  def proposed_by_link(conn, song = %Wcsp.Musics.Song{}) do
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
