# How to use it
# user = insert!(:user)
# song = insert!(:song, %{user: user})

defmodule WsdjsWeb.Factory do
  alias Wsdjs.Repo

  # Factories
  def build(:user) do
    %Wsdjs.Accounts.User{
      email: "user-#{System.unique_integer([:positive])}@wsdjs.com"
    }
  end

  def build(:song) do
    %Wsdjs.Musics.Song{
      title: "title-#{System.unique_integer([:positive])}",
      artist: "artist-#{System.unique_integer([:positive])}",
      genre: Enum.random(Wsdjs.Musics.Song.genre())
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
