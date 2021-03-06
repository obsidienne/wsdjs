defmodule WsdjsWeb.SongHelper do
  @moduledoc """
  This modules contains all helpers for a %Song{}.
  """
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song

  def url_for_provider(%Song{video_id: id}) when is_binary(id),
    do: "https://www.youtube.com/watch?v=#{id}"

  def url_for_provider(%Song{url: url}) when is_binary(url), do: url
  def url_for_provider(_), do: "#"

  def comment_class(song) do
    case Enum.count(song.comments) do
      0 -> "song-comment-empty"
      _ -> "song-comment"
    end
  end

  def utc_to_local(dt) do
    dt
    |> Timex.to_datetime()
    |> Timex.format!("{ISO:Extended}")
  end

  def blur_track(%Wsdjs.Musics.Song{hidden_track: false}, _), do: false
  def blur_track(%Wsdjs.Musics.Song{hidden_track: true}, %User{admin: true}), do: false
  def blur_track(%Wsdjs.Musics.Song{hidden_track: true, user_id: id}, %User{id: id}), do: false
  def blur_track(%Wsdjs.Musics.Song{hidden_track: true}, %User{profil_djvip: true}), do: false
  def blur_track(%Wsdjs.Musics.Song{hidden_track: true}, _), do: true
end
