defmodule Wcsp.Seeds do
  use Ecto.Schema

  def store_it(:user, row) do
    row = row
    |> Enum.filter(fn {_, v} -> v != "" end)
    |> Enum.into(%{})

    user = %Wcsp.Accounts.User{
      id: row[:id],
      email: row[:email],
      admin: row[:admin] == "true",
      djname: row[:djname],
      name: row[:name],
      user_country: row[:user_country],
      new_song_notification: row[:new_song_notification] == "true",
      inserted_at: Ecto.DateTime.cast!(row[:inserted_at]),
      updated_at: Ecto.DateTime.cast!(row[:updated_at])
    }
    user = Wcsp.Repo.insert! user

    avatar = case row do
      %{avatar_id: "wsdjs/missing_avatar"} ->
        nil
      %{avatar_id: ai, avatar_version: av} ->
        avatar = %Wcsp.Accounts.Avatar{
          cld_id: ai,
          user_id: user.id,
          version: String.to_integer(av)
        }
        Wcsp.Repo.insert! avatar
      _ ->
        nil
    end
  end


  def store_it(:top, row) do
    row = row
    |> Enum.filter(fn {_, v} -> v != "" end)
    |> Enum.into(%{})

    top = %Wcsp.Trendings.Top{
      id: row[:id],
      user_id: row[:user_id],
      due_date: Ecto.Date.cast!(row[:due_date]),
      status: row[:status],
      inserted_at: Ecto.DateTime.cast!(row[:inserted_at]),
      updated_at: Ecto.DateTime.cast!(row[:updated_at])
    }

    Wcsp.Repo.insert! top
  end

  def store_it(:song, row) do
    row = row
    |> Enum.filter(fn {_, v} -> v != "" end)
    |> Enum.into(%{})

    song = %Wcsp.Musics.Song{
      id: row[:id],
      user_id: row[:user_id],
      artist: row[:artist],
      title: row[:title],
      url: row[:song_url],
      bpm: case row[:bpm] do
        nil -> nil
        _ -> String.to_integer(row[:bpm])
        end,
      genre: row[:genre],
      inserted_at: Ecto.DateTime.cast!(row[:inserted_at]),
      updated_at: Ecto.DateTime.cast!(row[:updated_at])
    }
    Wcsp.Repo.insert! song
    store_it(:album_art, row)
  end

  def store_it(:album_art, %{cover_public_id: cpi, cover_version: cv, user_id: ui, id: id}) when cpi != "wsdjs/missing_cover" and cpi != "" do
    album_art = %Wcsp.Musics.Art{
      cld_id: cpi,
      version: String.to_integer(cv),
      song_id: id,
      user_id: ui
    }
    Wcsp.Repo.insert! album_art
  end
  def store_it(:album_art, _row) do true end

  def store_it(:rank, row) do
    rank = %Wcsp.Trendings.Rank{
      id: row[:id],
      top_id: row[:top_id],
      song_id: row[:song_id],
      likes: String.to_integer(row[:likes]),
      votes: String.to_integer(row[:votes]),
      bonus: String.to_integer(row[:bonus]),
      position: String.to_integer(row[:position]),
      inserted_at: Ecto.DateTime.cast!(row[:inserted_at]),
      updated_at: Ecto.DateTime.cast!(row[:updated_at])
    }
    Wcsp.Repo.insert! rank
  end

  def store_it(:vote, row) do
    row = row
    |> Enum.filter(fn {_, v} -> v != "" end)
    |> Enum.into(%{})

    vote = %Wcsp.Trendings.Vote{
      id: row[:id],
      user_id: row[:user_id],
      song_id: row[:song_id],
      top_id: row[:top_id],
      votes: String.to_integer(row[:position]),
      inserted_at: Ecto.DateTime.cast!(row[:inserted_at]),
      updated_at: Ecto.DateTime.cast!(row[:updated_at])
    }

    Wcsp.Repo.insert! vote
  end

  def store_it(:opinion, row) do
    song_opinion = %Wcsp.Musics.Opinion{
      id: row[:id],
      user_id: row[:user_id],
      song_id: row[:song_id],
      kind: row[:kind],
      inserted_at: Ecto.DateTime.cast!(row[:inserted_at]),
      updated_at: Ecto.DateTime.cast!(row[:updated_at])
    }
    Wcsp.Repo.insert! song_opinion
  end

  def store_it(:comment, row) do
    song_comment = %Wcsp.Musics.Comment{
      id: row[:id],
      user_id: row[:user_id],
      song_id: row[:song_id],
      text: row[:text],
      inserted_at: Ecto.DateTime.cast!(row[:inserted_at]),
      updated_at: Ecto.DateTime.cast!(row[:updated_at])
    }
    Wcsp.Repo.insert! song_comment
  end
end

#import users
"data/users.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :email, :admin, :new_song_notification, :user_country, :name, :djname, :avatar_id, :avatar_version, :inserted_at, :updated_at])
|> Enum.each(&Wcsp.Seeds.store_it(:user, &1))

"data/tops.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :user_id, :inserted_at, :updated_at, :due_date, :status])
|> Enum.each(&Wcsp.Seeds.store_it(:top, &1))

"data/songs.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :artist, :title, :inserted_at, :updated_at, :song_url, :cover_public_id, :cover_version, :bpm, :user_id, :genre])
|> Enum.each(&Wcsp.Seeds.store_it(:song, &1))

"data/ranks.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :top_id, :song_id, :likes, :inserted_at, :updated_at, :votes, :bonus, :points, :position])
|> Enum.each(&Wcsp.Seeds.store_it(:rank, &1))

"data/song_opinions.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :user_id, :song_id, :kind, :inserted_at, :updated_at])
|> Enum.each(&Wcsp.Seeds.store_it(:opinion, &1))

"data/song_comments.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :user_id, :song_id, :text, :inserted_at, :updated_at])
|> Enum.each(&Wcsp.Seeds.store_it(:comment, &1))


"data/votes.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :user_id, :top_id, :song_id, :position, :inserted_at, :updated_at])
|> Enum.each(&Wcsp.Seeds.store_it(:vote, &1))

# Historic data coming from anchorstep

"data/top_anchorstep.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :user_id, :inserted_at, :updated_at, :due_date, :status])
|> Enum.each(&Wcsp.Seeds.store_it(:top, &1))

"data/songs_anchorstep.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :artist, :title, :inserted_at, :updated_at, :song_url, :cover_public_id, :cover_version, :bpm, :user_id, :genre])
|> Enum.each(&Wcsp.Seeds.store_it(:song, &1))

"data/ranks_anchorstep.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :top_id, :song_id, :likes, :inserted_at, :updated_at, :votes, :bonus, :points, :position])
|> Enum.each(&Wcsp.Seeds.store_it(:rank, &1))
