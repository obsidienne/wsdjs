defmodule Wcsp.Seeds do
  use Wcsp.Model

  def store_it(row, :account) do
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

    account = case row do
      %{avatar_id: "wsdjs/missing_avatar"} ->
        account
      %{avatar_id: ai, avatar_version: av} ->
        {version, _} = Integer.parse(av)
        Map.put(account, :avatar, %Avatar{cld_id: ai, version: version})
      _ ->
        account
    end
    Wcsp.Repo.insert! account
  end


  def store_it(row, :tops) do
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
end

#import accounts
"data/accounts.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :email, :admin, :new_song_notification, :user_country, :name, :djname, :avatar_id, :avatar_version, :inserted_at, :updated_at])
|> Enum.each(&Wcsp.Seeds.store_it(&1, :account))

"data/tops.csv"
|> Path.expand(__DIR__)
|> File.stream!
|> Stream.drop(1)
|> CSV.decode(strip_cells: true, headers: [:id, :user_id, :inserted_at, :updated_at, :due_date, :status])
|> Enum.each(&Wcsp.Seeds.store_it(&1, :tops))
