defmodule Brididi.Repo.Migrations.CorrectData do
  use Ecto.Migration

  def change do
    execute "UPDATE songs SET url = REPLACE(url , 'https://www.youtube.com/watch?v=', 'https://youtu.be/')"

    execute "UPDATE songs SET url = REPLACE(url , 'https://m.youtube.com/watch?v=', 'https://youtu.be/')"

    execute "UPDATE songs SET url = REPLACE(url , 'http://youtu.be/', 'https://youtu.be/')"

    rename(table("songs"), :url, to: :youtube_url)
  end
end
