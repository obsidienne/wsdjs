defmodule Wcsp.Scope do
  use Wcsp.Model

  # admin is sees everything
  def scope(source, %User{admin: :true}), do: source

  # connected user
  def scope(source, %User{}), do: source

  # unauthenticated user sees only top ten songs
  def scope(Song, nil) do
    from s in Song,
    join: r in assoc(s, :ranks),
    where: r.position <= 10
  end

  # unauthenticated users cant see admin user
  def scope(User, nil) do
    from u in User,
    where: u.admin == false
  end
end
