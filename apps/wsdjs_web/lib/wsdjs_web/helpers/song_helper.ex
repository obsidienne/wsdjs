defmodule WsdjsWeb.SongHelper do
  @moduledoc """
  This modules contains all helpers for a %Song{}.
  """
  alias Wsdjs.Musics.Song

  def url_for_provider(%Song{video_id: id}) when is_binary(id), do: "http://youtu.be/#{id}"
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

  def blur_track(%Wsdjs.Musics.Song{hidden_track: false}, _), do: ""
  def blur_track(%Wsdjs.Musics.Song{} = song, current_user) do
    cond do
      is_nil(current_user) ->
        "blur_track"
      current_user.admin == true ->
        ""
      Enum.member?(current_user.profils, "DJ_VIP") ->
        ""
      song.user_id == current_user.id ->
        ""
      true ->
        "blur_track"
    end
  end
end
