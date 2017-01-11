defmodule Wcsp.Seeds do
  use Wcsp.Model

  def store_it(row, :account) do
    row = row
    |> Enum.filter(fn {_, v} -> v != "" end)
    |> Enum.into(%{})

    row = Map.put(row, :admin, row[:admin] == "true")
    row = Map.put(row, :new_song_notification, row[:new_song_notification] == "true")
    row = Map.put(row, :inserted_at, Ecto.DateTime.cast!(row[:inserted_at]))
    row = Map.put(row, :updated_at, Ecto.DateTime.cast!(row[:updated_at]))

    row = extract_and_store_photo(row)

    IO.inspect row
    Wcsp.Repo.insert_all(Account, [row])
  end

  def extract_and_store_photo(row) do
    params = Map.take(row, [:avatar_id, :avatar_version])
    row = Map.drop(row, [:avatar_id, :avatar_version])

    #photo_id = Wscp.Repo.insert!(%Photo{}, params)
  end

  def store_it(:song, row) do

  end
end


account_header = [:id, :email, :admin, :new_song_notification, :user_country, :name, :djname, :avatar_id, :avatar_version, :inserted_at, :updated_at]

#import accounts
"data/accounts.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(headers: account_header, strip_cells: true)
|> Enum.each(&Wcsp.Seeds.store_it(&1, :account))
