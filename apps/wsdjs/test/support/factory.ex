defmodule Wsdjs.Factory do
  use ExMachina.Ecto, repo: Wsdjs.Repo

  def user_factory do
    %Wsdjs.Accounts.User{
      name: "Jane Smith",
      email: sequence(:email, &"email-#{&1}@example.com"),
      admin: false,
      profil_djvip: false,
      profil_dj: false,
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
      url: "http://youtu.be/toto",
      bpm: 1,
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

  def opinion_factory do
    %Wsdjs.Musics.Opinion {
      kind: "like",
      user: build(:user),
      song: build(:song)
    }
  end

  def vote_factory do
    %Wsdjs.Charts.Vote {
      votes: System.unique_integer([:positive]),
      song: build(:song),
      top: build(:top),
      user: build(:user)
    }
  end
end