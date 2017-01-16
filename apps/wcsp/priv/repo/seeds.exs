defmodule Wcsp.Seeds do
  use Wcsp.Model

  def store_it(:account, row) do
    row = row
    |> Enum.filter(fn {_, v} -> v != "" end)
    |> Enum.into(%{})

    account = %Wcsp.Account{
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
    account = Wcsp.Repo.insert! account

    avatar = case row do
      %{avatar_id: "wsdjs/missing_avatar"} ->
        nil
      %{avatar_id: ai, avatar_version: av} ->
        version = String.to_integer(av)
        #avatar = Wcsp.Repo.insert! %Avatar{cld_id: ai, version: version}
        #Wcsp.Repo.update_all account, set: [avatar_id: avatar[:id]]
      _ ->
        nil
    end
  end


  def store_it(:top, row) do
    row = row
    |> Enum.filter(fn {_, v} -> v != "" end)
    |> Enum.into(%{})

    top = %Wcsp.Top{
      id: row[:id],
      account_id: row[:user_id],
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

    song = %Wcsp.Song{
      id: row[:id],
      account_id: row[:user_id],
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
    album_art = %Wcsp.AlbumArt{
      cld_id: cpi,
      version: String.to_integer(cv),
      song_id: id,
      account_id: ui
    }
    Wcsp.Repo.insert! album_art
  end
  def store_it(:album_art, _row) do true end

  def store_it(:rank, row) do
  end
end

#import accounts
"data/accounts.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :email, :admin, :new_song_notification, :user_country, :name, :djname, :avatar_id, :avatar_version, :inserted_at, :updated_at])
|> Enum.each(&Wcsp.Seeds.store_it(:account, &1))

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
|> CSV.decode(strip_cells: true, headers: [:id, :top_id, :song_id, :likes, :inserted_at, :updated_at, :votes, :bonus, :points])
|> Enum.each(&Wcsp.Seeds.store_it(:rank, &1))
