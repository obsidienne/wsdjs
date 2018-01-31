defmodule Wsdjs.Jobs.UpdatePlaylists do
@doc """
    insert into playlists(name, type, user_id, inserted_at, updated_at)
        select distinct 'suggested'
               ,'suggested'
               ,user_id, now() at time zone 'utc'
               ,now() at time zone 'utc'
        from songs 
        where user_id not in (select user_id from playlists where type='suggested');

"""
  import Ecto.Query, warn: false

  alias Wsdjs.Repo
  alias Wsdjs.Playlists.Playlist
  alias Wsdjs.Musics.Song

  def call(_args \\ []) do
    delete_suggested()
    insert_suggested()
    update_suggested()

    delete_toplike()
    insert_toplike()
    update_toplike()
  end

  ###############################################
  #
  # suggested
  #
  ###############################################
  def delete_suggested() do
    query = "DELETE from playlists where type='suggested' and user_id not in (select user_id from songs)"
    Ecto.Adapters.SQL.query!(Repo, query)
  end

  def insert_suggested() do
    query = "
      insert into playlists(name, type, user_id, inserted_at, updated_at)
      select distinct 'suggested'
            ,'suggested'
            ,user_id, now() at time zone 'utc'
            ,now() at time zone 'utc'
      from songs 
      where user_id not in (select user_id from playlists where type='suggested')
    "

    Ecto.Adapters.SQL.query!(Repo, query)
  end

  
  def update_suggested() do
    query = "
      update playlists p 
      set count=(select count(*) from songs s where p.user_id=s.user_id)
        , song_id=(select id from songs s where p.user_id=s.user_id order by inserted_at desc LIMIT 1)
      where p.type='suggested'
    "

    Ecto.Adapters.SQL.query!(Repo, query)
  end

  ###############################################
  #
  # top or like
  #
  ###############################################
  def delete_toplike() do
    query = "DELETE from playlists where type='top or like' and user_id not in (select user_id from opinions)"
    Ecto.Adapters.SQL.query!(Repo, query)
  end

  def insert_toplike() do
    query = "
      insert into playlists(name, type, user_id, inserted_at, updated_at)
      select distinct 'top or like'
            ,'top or like'
            ,user_id, now() at time zone 'utc'
            ,now() at time zone 'utc'
      from songs 
      where user_id not in (select user_id from playlists where type='top or like')
    "

    Ecto.Adapters.SQL.query!(Repo, query)
  end

  
  def update_toplike() do
    query = "
      update playlists p 
      set count=(select count(*) from opinions o where p.user_id=o.user_id)
        , song_id=(select song_id from opinions o where p.user_id=o.user_id order by inserted_at desc LIMIT 1)
      where p.type='top or like'
    "

    Ecto.Adapters.SQL.query!(Repo, query)
  end
end