defmodule Wcsp.Dj do
  @moduledoc ~S"""
  Contains dj business logic of the platform.

  `Dj` will be used by `wcs_web` Phoenix apps.
  """
  alias Wcsp.Repo
  use Wcsp.Model

  def songs_with_album_art() do
    Repo.all from p in Song, preload: [:album_art, :account]
  end

  def find_song(id) do
    song = Repo.get(Song, id)
    song = Repo.preload(song, [:album_art, :account])
  end

  def tops do
    tops = Wcsp.Top.tops() |> Repo.all
    Repo.preload tops, ranks: Wcsp.Rank.for_tops_with_limit()
  end

  def top(id) do
    top = Wcsp.Top.top(id) |> Repo.one
    top_with_songs = Repo.preload top, ranks: Wcsp.Rank.for_top(id)
  end

  def search(q) do
    query = """
        SELECT  "songs"."id", "songs"."artist", "songs"."title", "songs"."genre", "songs"."bpm", "songs"."inserted_at",
        "album_arts"."cld_id" AS album_art_cld_id, "album_arts"."version" as album_art_version,
        "avatars"."cld_id" AS avatar_cld_id, "avatars"."version" AS avatar_version,
        "accounts"."name", "accounts"."djname",
        COALESCE(similarity("songs"."artist", $1), 0) + COALESCE(similarity("songs"."title", $1), 0) AS "rank"
        FROM "songs"
        LEFT JOIN "album_arts" ON "album_arts"."song_id" = "songs"."id"
        LEFT JOIN "accounts" ON "songs"."account_id" = "accounts"."id"
        LEFT JOIN "avatars" ON "avatars"."account_id" = "accounts"."id"
        WHERE (("songs"."artist" % $1)
           OR ("songs"."title" % $1))
        ORDER BY "rank" DESC
        LIMIT 5
    """
    {:ok, results} = Ecto.Adapters.SQL.query(Wcsp.Repo, query, [q])
    cols = Enum.map results.columns, &(String.to_atom(&1))
    Enum.map results.rows, fn(row) -> Map.new(Enum.zip(cols, row)) end
  end
end
