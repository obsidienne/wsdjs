defmodule Wsdjs.Factory do
  use ExMachina.Ecto, repo: Wsdjs.Repo

  def user_factory do
    %Wsdjs.Accounts.User{
      name: "Jane Smith",
      email: sequence(:email, &"email-#{&1}@example.com"),
      profils: [],
      admin: false,
    }
  end

  def song_factory do
    %Wsdjs.Musics.Song {
      title: sequence(:title, &"title-#{&1}"),
      artist: sequence(:artist, &"artist-#{&1}"),
      genre: Enum.random(Wsdjs.Musics.Song.genre()),
      instant_hit: false,
      public_track: false,
      hidden_track: false,
      user: build(:user),
      bpm: 0,
    }
  end

  def top_factory do
    %Wsdjs.Charts.Top {
      due_date: Timex.beginning_of_month(Timex.today),
      status: "checking",
      user: build(:user),
    }
  end

  def rank_factory do
    %Wsdjs.Charts.Rank {
      song: build(:song),
      top: build(:top)
    }
  end
end