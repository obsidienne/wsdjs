defmodule Wcsp do
  @moduledoc ~S"""
  Contains main business logic of the project.

  `Wcsp` is used by `wsdjs_web` Phoenix app.
  """
  use Wcsp.Model

  def users do
    User
    |> Repo.all
  end

  def find_user!(clauses) do
    Repo.get_by!(User, clauses)
    |> Repo.preload(:avatar)
  end

  def find_user(clauses) do
    Repo.get_by(User, clauses)
    |> Repo.preload(:avatar)
  end

  def hot_songs() do
    Song
    |> preload([:album_art, :user])
    |> order_by(desc: :inserted_at)
    |> Repo.all
  end

  def find_song!(clauses) do
    Repo.get_by!(Song, clauses)
    |> Repo.preload([:album_art, :user])
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
        "users"."name", "users"."djname",
        COALESCE(similarity("songs"."artist", $1), 0) + COALESCE(similarity("songs"."title", $1), 0) AS "rank"
        FROM "songs"
        LEFT JOIN "album_arts" ON "album_arts"."song_id" = "songs"."id"
        LEFT JOIN "users" ON "songs"."user_id" = "users"."id"
        LEFT JOIN "avatars" ON "avatars"."user_id" = "users"."id"
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
