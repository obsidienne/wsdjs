defmodule Wscp.Policy do
  use Wcsp.Model

  # Admin users are god
  def can?(%User{admin: :true}, _action, _struct), do: true

  # Regular users can modify their own songs
  def can?(%User{id: user_id, admin: :false}, _action, %Song{user_id: song_user_id})
     when user_id == song_user_id, do: true


  # anonymous users
  def can?(_user, :index, Song), do: true
  def can?(_user, :show, _song), do: true


  # Catch-all: deny everything else
  def can?(_, _, _), do: false
end
