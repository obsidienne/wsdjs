# How to use it
# user = insert!(:user)
# song = insert!(:song, %{user: user})

defmodule WsdjsWeb.Factory do
  alias Wsdjs.Repo

  # Factories
  def build(:user) do
    %Wsdjs.Accounts.User{
      email: "user-#{System.unique_integer([:positive])}@wsdjs.com",
      name: "John Doe-#{System.unique_integer([:positive])}",
      profils: []
    }
  end

  def build(:all_users_type) do
    users = %{
      user: insert!(:user),
      user2: insert!(:user),
      dj: insert!(:user, profils: ["DJ"]),
      dj2: insert!(:user, profils: ["DJ"]),
      dj_vip: insert!(:user, profils: ["DJ_VIP"]),
      dj_vip2: insert!(:user, profils: ["DJ_VIP"]),
      admin: insert!(:user, %{admin: true})
    }
  end

  def build(:song) do
    %Wsdjs.Musics.Song{
      title: "title-#{System.unique_integer([:positive])}",
      artist: "artist-#{System.unique_integer([:positive])}",
      genre: Enum.random(Wsdjs.Musics.Song.genre())
    }
  end
  
  def build(:top) do
    %Wsdjs.Charts.Top{
      due_date: Timex.beginning_of_month(Timex.today),
      status: "checking"
    }
  end

  def build(:comment) do
    %Wsdjs.Musics.Comment{
      text: "comment #{System.unique_integer([:positive])}"
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert! build(factory_name, attributes)
  end
end
