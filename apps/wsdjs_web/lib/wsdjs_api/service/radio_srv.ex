defmodule WsdjsApi.Service.RadioSrv do
  alias Wsdjs.Musics
  import WsdjsWeb.Router.Helpers

  def streamed(conn) do
    ConCache.get_or_store(:wsdjs_cache, "streamed_songs_json", fn() ->
      json = ConCache.get(:wsdjs_cache, "streamed_songs")
      render(conn, json)
    end)
  end

  defp render(_conn, nil), do: ""
  defp render(conn, songs) when is_list(songs) do
    Enum.map(songs, fn s ->
      render(conn, s, Musics.get_song_by(s["artist"], s["title"]))
    end)
    |> Poison.encode!()
  end

  defp render(_conn, s, nil) when is_map(s), do: s
  defp render(conn, s, %Wsdjs.Musics.Song{} = song) when is_map(s) do
    s
    |> Map.put(:suggested_ts, Timex.to_unix(song.inserted_at))
    |> Map.put(:image_uri, WsdjsWeb.CloudinaryHelper.art_url(song.art, 900))
    |> Map.put(:image_srcset, WsdjsWeb.CloudinaryHelper.art_srcset(song.art, 300))
    |> Map.put(:suggested_by, song.user.name)
    |> Map.put(:suggested_by_path, user_path(conn, :show, song.user))
    |> Map.put(:path, song_path(conn, :show, song))
    |> Map.put(:tags, tags_for_song(song))
    |> Map.put(:song_id, song.id)
  end

  defp tags_for_song(song) do
    with {:ok, top_head} <- Enum.fetch(song.tops, 0),
         {:ok, rank_head} <- Enum.fetch(top_head.ranks, 0),
         {:ok, _} <- song_position(rank_head.position) do
      ["Top " <> Timex.format!(top_head.due_date, "%b%y", :strftime)]
    else
      _ -> []
    end
  end

  defp song_position(pos) when pos <= 10, do: {:ok, pos}
  defp song_position(pos) when pos > 10, do: {:ko, pos}
end
