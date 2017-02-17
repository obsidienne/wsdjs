defmodule Wcsp.Factory do
  alias Wcsp.Repo
  alias Wcsp.SongComment
  use Wcsp.Model

  # Factories
  def build(:user) do
    %User{
      email: "hello#{System.unique_integer()}@dummy.com"
    }
  end

  def build(:song) do
    %Song{
      title: "title #{System.unique_integer()}",
      artist: "artist #{System.unique_integer()}",
      url: "http://urlsong.com",
      bpm: 90,
      genre: "acoustic"
    }
  end

  # def build(:songComment) do
  #   %SongComment{
  #     text: "Test text #{System.unique_integer()}"
  #     belongs_to user: build(:user)
  #     belongs_to song: build(:song)
  #   }
  # end

  # Convenience API
  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert! build(factory_name, attributes)
  end

end
