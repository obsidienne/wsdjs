defmodule Wsdjs.Factory do
  use ExMachina.Ecto, repo: Wsdjs.Repo

  def user_factory do
    %Wsdjs.Accounts.User{
      name: "Jane Smith",
      email: sequence(:email, &"email-#{&1}@example.com"),
      admin: false,
      profil_djvip: false,
      profil_dj: false,
      deactivated: false,
      detail: build(:detail)
    }
  end

  def detail_factory do
    %Wsdjs.Accounts.UserDetail{}
  end

  def top_factory do
    %Wsdjs.Charts.Top{
      due_date: Timex.beginning_of_month(Timex.today()),
      status: "checking",
      user: build(:user)
    }
  end

  def rank_factory do
    %Wsdjs.Charts.Rank{
      song: build(:song),
      top: build(:top)
    }
  end

  def opinion_factory do
    %Wsdjs.Reactions.Opinion{
      kind: "like",
      user: build(:user),
      song: build(:song)
    }
  end

  def vote_factory do
    %Wsdjs.Charts.Vote{
      votes: System.unique_integer([:positive]),
      song: build(:song),
      top: build(:top),
      user: build(:user)
    }
  end

  def comment_factory do
    %Wsdjs.Reactions.Comment{
      text: "dummy text",
      user: build(:user),
      song: build(:song)
    }
  end
end
