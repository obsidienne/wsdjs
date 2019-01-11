defmodule Wsdjs.Repo.Migrations.ChangePrimaryKey do
  use Ecto.Migration

  def change do
    remove_primarykey_contraints()
    rename_primary_key()
    rename_foreign_key()
    create_new_foreign_key()
    create_new_primary_key()
    fill_foreign_key()
    create_constraints()
  end

  defp remove_primarykey_contraints do
    execute "ALTER TABLE arts DROP CONSTRAINT album_arts_pkey CASCADE"
    execute "ALTER TABLE auth_tokens DROP CONSTRAINT auth_tokens_pkey CASCADE"
    execute "ALTER TABLE avatars DROP CONSTRAINT avatars_pkey CASCADE"
    execute "ALTER TABLE comments DROP CONSTRAINT comments_pkey CASCADE"
    execute "ALTER TABLE opinions DROP CONSTRAINT song_opinions_pkey CASCADE"
    execute "ALTER TABLE ranks DROP CONSTRAINT ranks_pkey CASCADE"
    execute "ALTER TABLE songs DROP CONSTRAINT songs_pkey CASCADE"
    execute "ALTER TABLE tops DROP CONSTRAINT tops_pkey CASCADE"
    execute "ALTER TABLE user_details DROP CONSTRAINT user_details_pkey CASCADE"
    execute "ALTER TABLE users DROP CONSTRAINT users_pkey CASCADE"
    execute "ALTER TABLE videos DROP CONSTRAINT videos_pkey CASCADE"
    execute "ALTER TABLE votes DROP CONSTRAINT rank_songs_pkey CASCADE"

    alter table(:auth_tokens) do
      remove :id
    end

    alter table(:user_details) do
      remove :id
    end
  end

  defp rename_primary_key do
    rename(table("arts"), :id, to: :uuid)
    rename(table("avatars"), :id, to: :uuid)
    rename(table("comments"), :id, to: :uuid)
    rename(table("opinions"), :id, to: :uuid)
    rename(table("ranks"), :id, to: :uuid)
    rename(table("songs"), :id, to: :uuid)
    rename(table("tops"), :id, to: :uuid)
    rename(table("users"), :id, to: :uuid)
    rename(table("videos"), :id, to: :uuid)
    rename(table("votes"), :id, to: :uuid)

    alter table(:tops) do
      modify :uuid, :binary_id, null: true
    end

    alter table(:songs) do
      modify :uuid, :binary_id, null: true
    end

    alter table(:users) do
      modify :uuid, :binary_id, null: true
    end
  end

  defp rename_foreign_key do
    rename(table("arts"), :song_id, to: :song_uuid)
    rename(table("auth_tokens"), :user_id, to: :user_uuid)
    rename(table("avatars"), :user_id, to: :user_uuid)
    rename(table("comments"), :user_id, to: :user_uuid)
    rename(table("comments"), :song_id, to: :song_uuid)
    rename(table("events"), :user_id, to: :user_uuid)
    rename(table("opinions"), :user_id, to: :user_uuid)
    rename(table("opinions"), :song_id, to: :song_uuid)
    rename(table("playlist_songs"), :song_id, to: :song_uuid)
    rename(table("playlists"), :cover_id, to: :cover_uuid)
    rename(table("playlists"), :user_id, to: :user_uuid)
    rename(table("ranks"), :song_id, to: :song_uuid)
    rename(table("ranks"), :top_id, to: :top_uuid)
    rename(table("songs"), :user_id, to: :user_uuid)
    rename(table("tops"), :user_id, to: :user_uuid)
    rename(table("user_details"), :user_id, to: :user_uuid)
    rename(table("user_parameters"), :user_id, to: :user_uuid)
    rename(table("videos"), :user_id, to: :user_uuid)
    rename(table("videos"), :song_id, to: :song_uuid)
    rename(table("votes"), :user_id, to: :user_uuid)
    rename(table("votes"), :song_id, to: :song_uuid)
    rename(table("votes"), :top_id, to: :top_uuid)
  end

  #
  # create new foreign key
  #
  defp create_new_foreign_key do
    execute "ALTER TABLE arts ADD COLUMN song_id BIGINT"
    execute "ALTER TABLE auth_tokens ADD COLUMN user_id BIGINT"
    execute "ALTER TABLE avatars ADD COLUMN user_id BIGINT"
    execute "ALTER TABLE comments ADD COLUMN user_id BIGINT"
    execute "ALTER TABLE comments ADD COLUMN song_id BIGINT"
    execute "ALTER TABLE events ADD COLUMN user_id BIGINT"
    execute "ALTER TABLE opinions ADD COLUMN user_id BIGINT"
    execute "ALTER TABLE opinions ADD COLUMN song_id BIGINT"
    execute "ALTER TABLE playlist_songs ADD COLUMN song_id BIGINT"
    execute "ALTER TABLE playlists ADD COLUMN cover_id BIGINT"
    execute "ALTER TABLE playlists ADD COLUMN user_id BIGINT"
    execute "ALTER TABLE ranks ADD COLUMN song_id BIGINT"
    execute "ALTER TABLE ranks ADD COLUMN top_id BIGINT"
    execute "ALTER TABLE songs ADD COLUMN user_id BIGINT"
    execute "ALTER TABLE tops ADD COLUMN user_id BIGINT"
    execute "ALTER TABLE user_details ADD COLUMN user_id BIGINT"
    execute "ALTER TABLE user_parameters ADD COLUMN user_id BIGINT"
    execute "ALTER TABLE videos ADD COLUMN user_id BIGINT"
    execute "ALTER TABLE videos ADD COLUMN song_id BIGINT"
    execute "ALTER TABLE votes ADD COLUMN user_id BIGINT"
    execute "ALTER TABLE votes ADD COLUMN song_id BIGINT"
    execute "ALTER TABLE votes ADD COLUMN top_id BIGINT"
  end

  #
  # create new primary key as a bigserial
  #
  defp create_new_primary_key do
    execute "ALTER TABLE arts ADD COLUMN id BIGSERIAL PRIMARY KEY"
    execute "ALTER TABLE auth_tokens ADD COLUMN id BIGSERIAL PRIMARY KEY"
    execute "ALTER TABLE avatars ADD COLUMN id BIGSERIAL PRIMARY KEY"
    execute "ALTER TABLE comments ADD COLUMN id BIGSERIAL PRIMARY KEY"
    # events not needed
    execute "ALTER TABLE opinions ADD COLUMN id BIGSERIAL PRIMARY KEY"
    # playlist_songs not needed
    execute "ALTER TABLE ranks ADD COLUMN id BIGSERIAL PRIMARY KEY"
    execute "ALTER TABLE songs ADD COLUMN id BIGSERIAL PRIMARY KEY"
    execute "ALTER TABLE tops ADD COLUMN id BIGSERIAL PRIMARY KEY"
    execute "ALTER TABLE user_details ADD COLUMN id BIGSERIAL PRIMARY KEY"
    # user_parameters not needed
    execute "ALTER TABLE users ADD COLUMN id BIGSERIAL PRIMARY KEY"
    execute "ALTER TABLE videos ADD COLUMN id BIGSERIAL PRIMARY KEY"
    execute "ALTER TABLE votes ADD COLUMN id BIGSERIAL PRIMARY KEY"
  end

  defp fill_foreign_key do
    execute "update arts set song_id = (select id from songs where uuid=song_uuid)"
    execute "update auth_tokens set user_id = (select id from users where uuid=user_uuid)"
    execute "update avatars set user_id = (select id from users where uuid=user_uuid)"
    execute "update comments set user_id = (select id from users where uuid=user_uuid)"
    execute "update comments set song_id = (select id from songs where uuid=song_uuid)"
    execute "update events set user_id = (select id from users where uuid=user_uuid)"
    execute "update opinions set user_id = (select id from users where uuid=user_uuid)"
    execute "update opinions set song_id = (select id from songs where uuid=song_uuid)"
    execute "update playlist_songs set song_id = (select id from songs where uuid=song_uuid)"
    execute "update playlists set cover_id = (select id from songs where uuid=cover_uuid)"
    execute "update playlists set user_id = (select id from users where uuid=user_uuid)"
    execute "update ranks set song_id = (select id from songs where uuid=song_uuid)"
    execute "update ranks set top_id = (select id from tops where uuid=top_uuid)"
    execute "update songs set user_id = (select id from users where uuid=user_uuid)"
    execute "update tops set user_id = (select id from users where uuid=user_uuid)"
    execute "update user_details set user_id = (select id from users where uuid=user_uuid)"
    execute "update user_parameters set user_id = (select id from users where uuid=user_uuid)"
    execute "update videos set user_id = (select id from users where uuid=user_uuid)"
    execute "update videos set song_id = (select id from songs where uuid=song_uuid)"
    execute "update votes set song_id = (select id from songs where uuid=song_uuid)"
    execute "update votes set user_id = (select id from users where uuid=user_uuid)"
    execute "update votes set top_id = (select id from tops where uuid=top_uuid)"
  end

  defp create_constraints do
    #
    #  Not null
    #

    alter table(:arts) do
      modify :song_id, :bigint, null: false
    end

    alter table(:auth_tokens) do
      modify :user_id, :bigint, null: false
    end

    alter table(:avatars) do
      modify :user_id, :bigint, null: false
    end

    alter table(:comments) do
      modify :user_id, :bigint, null: false
      modify :song_id, :bigint, null: false
    end

    alter table(:events) do
      modify :user_id, :bigint, null: false
    end

    alter table(:opinions) do
      modify :user_id, :bigint, null: false
      modify :song_id, :bigint, null: false
    end

    alter table(:playlist_songs) do
      modify :song_id, :bigint, null: false
    end

    alter table(:playlists) do
      modify :user_id, :bigint, null: false
    end

    alter table(:ranks) do
      modify :top_id, :bigint, null: false
      modify :song_id, :bigint, null: false
    end

    alter table(:songs) do
      modify :user_id, :bigint, null: false
    end

    alter table(:tops) do
      modify :user_id, :bigint, null: false
    end

    alter table(:user_details) do
      modify :user_id, :bigint, null: false
    end

    alter table(:user_parameters) do
      modify :user_id, :bigint, null: false
    end

    alter table(:videos) do
      modify :user_id, :bigint, null: false
      modify :song_id, :bigint, null: false
    end

    alter table(:votes) do
      modify :user_id, :bigint, null: false
      modify :song_id, :bigint, null: false
      modify :top_id, :bigint, null: false
    end

    #
    # foreign keys
    #
    execute "ALTER TABLE comments ADD FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE"
    execute "ALTER TABLE arts ADD FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE"

    execute "ALTER TABLE opinions ADD FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE"

    execute "ALTER TABLE playlists ADD FOREIGN KEY (cover_id) REFERENCES songs(id) ON DELETE SET NULL"

    execute "ALTER TABLE auth_tokens ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE avatars ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE comments ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE events ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE playlist_songs ADD FOREIGN KEY (song_id) REFERENCES songs(id)"
    execute "ALTER TABLE playlists ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE ranks ADD FOREIGN KEY (song_id) REFERENCES songs(id)"
    execute "ALTER TABLE ranks ADD FOREIGN KEY (top_id) REFERENCES tops(id)"
    execute "ALTER TABLE songs ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE tops ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE user_details ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE user_parameters ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE videos ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE videos ADD FOREIGN KEY (song_id) REFERENCES songs(id)"
    execute "ALTER TABLE votes ADD FOREIGN KEY (song_id) REFERENCES songs(id)"
    execute "ALTER TABLE votes ADD FOREIGN KEY (user_id) REFERENCES users(id)"
    execute "ALTER TABLE votes ADD FOREIGN KEY (top_id) REFERENCES tops(id) "
  end
end
