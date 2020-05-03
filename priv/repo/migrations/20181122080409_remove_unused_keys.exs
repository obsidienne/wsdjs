defmodule Wsdjs.Repo.Migrations.RemoveUnusedKeys do
  use Ecto.Migration

  def change do
    alter table(:arts) do
      remove :uuid
      remove :song_uuid
    end

    alter table(:auth_tokens) do
      remove :user_uuid
    end

    alter table(:avatars) do
      remove :uuid
      remove :user_uuid
    end

    alter table(:comments) do
      remove :uuid
      remove :user_uuid
      remove :song_uuid
    end

    alter table(:events) do
      remove :user_uuid
    end

    alter table(:opinions) do
      remove :uuid
      remove :user_uuid
      remove :song_uuid
    end

    alter table(:playlist_songs) do
      remove :song_uuid
    end

    alter table(:playlists) do
      remove :cover_uuid
      remove :user_uuid
    end

    alter table(:ranks) do
      remove :uuid
      remove :top_uuid
      remove :song_uuid
    end

    alter table(:songs) do
      remove :user_uuid
    end

    alter table(:tops) do
      remove :user_uuid
    end

    alter table(:user_details) do
      remove :user_uuid
    end

    alter table(:user_parameters) do
      remove :user_uuid
    end

    alter table(:videos) do
      remove :uuid
      remove :user_uuid
      remove :song_uuid
    end

    alter table(:votes) do
      remove :uuid
      remove :user_uuid
      remove :song_uuid
      remove :top_uuid
    end
  end
end
