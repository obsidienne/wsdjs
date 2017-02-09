defmodule Wcsp.Scope do
  use Wcsp.Model

  def scope(Song, %User{admin: :true}), do: Song
  def scope(Song, %User{admin: :false}), do: Song
  def scope(Song, nil) do
    from s in Song,
    join: r in assoc(s, :ranks),
    where: r.position <= 10
  end
end
