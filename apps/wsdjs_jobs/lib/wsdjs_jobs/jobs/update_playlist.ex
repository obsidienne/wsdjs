defmodule Wsdjs.Jobs.UpdatePlaylists do
  @moduledoc """
  This modules contains the database calls needed to fill the automatic user
  playlists.
  """
  import Ecto.Query, warn: false

  alias Wsdjs.Repo

  def call(_args \\ []) do
    delete_suggested()
    insert_suggested()
    update_suggested()

    delete_toplike()
    insert_toplike()
    update_toplike()

    insert_top5_current()
    insert_top5_classic()
  end

  ###############################################
  #
  # DJ VIP - TOP 5
  #
  ###############################################
  def insert_top5_current do
    query = "
      insert into playlists(name, type, user_id, public, inserted_at, updated_at)
      select distinct 'TOP 5 current'
            ,'top 5'
            ,id
            ,false
            ,now() at time zone 'utc'
            ,now() at time zone 'utc'
      from users
      where id not in (select user_id from playlists where type='top 5' and name = 'TOP 5 current')
        and (admin = true)
    "

    Ecto.Adapters.SQL.query!(Repo, query)
  end

  def insert_top5_classic do
    query = "
      insert into playlists(name, type, user_id, public, inserted_at, updated_at)
      select distinct 'TOP 5 classic'
            ,'top 5'
            ,id
            ,false
            ,now() at time zone 'utc'
            ,now() at time zone 'utc'
      from users
      where id not in (select user_id from playlists where type='top 5' and name = 'TOP 5 classic')
        and (admin = true)
    "

    Ecto.Adapters.SQL.query!(Repo, query)
  end

  ###############################################
  #
  # suggested
  #
  ###############################################
  def delete_suggested do
    query =
      "DELETE from playlists where type='suggested' and user_id not in (select user_id from songs)"

    Ecto.Adapters.SQL.query!(Repo, query)
  end

  def insert_suggested do
    query = "
      insert into playlists(name, type, user_id, public, inserted_at, updated_at)
      select distinct 'suggested'
            ,'suggested'
            ,user_id
            ,true
            ,now() at time zone 'utc'
            ,now() at time zone 'utc'
      from songs
      where user_id not in (select user_id from playlists where type='suggested')
    "

    Ecto.Adapters.SQL.query!(Repo, query)
  end

  # update the playlist entity to set the suggestion count and the playlist cover image
  def update_suggested do
    query = "
      update playlists p
      set count=(select count(*) from songs s where p.user_id=s.user_id)
        , cover_id=(select id from songs s where p.user_id=s.user_id order by inserted_at desc LIMIT 1)
      where p.type='suggested'
    "

    Ecto.Adapters.SQL.query!(Repo, query)
  end

  ###############################################
  #
  # top or like
  #
  ###############################################
  def delete_toplike do
    query =
      "DELETE from playlists where type='likes and tops' and user_id not in (select user_id from opinions)"

    Ecto.Adapters.SQL.query!(Repo, query)
  end

  def insert_toplike do
    query = "
      insert into playlists(name, type, user_id, inserted_at, updated_at)
      select distinct 'likes and tops'
            ,'likes and tops'
            ,user_id, now() at time zone 'utc'
            ,now() at time zone 'utc'
      from opinions
      where user_id not in (select user_id from playlists where type='likes and tops')
    "

    Ecto.Adapters.SQL.query!(Repo, query)
  end

  # update the playlist entity to set the top/like count and the playlist cover image
  def update_toplike do
    query = "
      update playlists p
      set count=(select count(*) from opinions o where p.user_id=o.user_id)
        , cover_id=(select song_id from opinions o where p.user_id=o.user_id order by inserted_at desc LIMIT 1)
      where p.type='likes and tops'
    "

    Ecto.Adapters.SQL.query!(Repo, query)
  end
end
