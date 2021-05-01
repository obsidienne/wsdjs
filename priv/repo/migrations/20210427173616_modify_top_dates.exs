defmodule Brididi.Repo.Migrations.ModifyTopDates do
  use Ecto.Migration

  def change do
    alter table(:tops) do
      add :start_date, :date
      add :end_date, :date
    end

    execute("UPDATE tops set start_date=due_date")

    execute(
      "UPDATE tops set end_date=(date_trunc('MONTH', due_date)::DATE + INTERVAL '1 MONTH - 1 day')::DATE"
    )

    alter table(:tops) do
      modify :start_date, :date, null: false
      modify :end_date, :date, null: false
    end
  end
end
