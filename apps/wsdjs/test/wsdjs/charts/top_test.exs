defmodule Wsdjs.Charts.TopTest do
  use Wsdjs.DataCase, async: true

  alias Wsdjs.Charts
  alias Wsdjs.Charts.Top
  alias Wsdjs.Repo

  describe "changeset" do
    test "changeset with minimal valid attributes" do
      changeset =
        Top.create_changeset(%Top{}, %{due_date: Timex.today(), user_id: Ecto.UUID.generate()})

      assert changeset.valid?
    end

    test "top owner accout must exist" do
      top =
        Top.create_changeset(%Top{}, %{due_date: Timex.today(), user_id: Ecto.UUID.generate()})

      assert {:error, %Ecto.Changeset{} = changeset} = Repo.insert(top)
      assert "does not exist" in errors_on(changeset).user
    end
  end

  describe "Published top" do
    alias Wsdjs.Accounts.User

    test "current month" do
      top = top_fixture("published", 0)

      assert [top] == %User{admin: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [top] ==
               %User{profil_djvip: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [] == %User{profil_dj: true} |> Top.scoped() |> Repo.all()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end

    test "current month -2" do
      top = top_fixture("published", -2)

      assert [top] == %User{admin: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [top] ==
               %User{profil_djvip: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [] == %User{profil_dj: true} |> Top.scoped() |> Repo.all()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end

    test "current month -3" do
      top = top_fixture("published", -3)

      assert [top] == %User{admin: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [top] ==
               %User{profil_djvip: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [top] == %User{profil_dj: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)
      assert [top] == nil |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)
    end

    test "current month -5" do
      top = top_fixture("published", -5)

      assert [top] == %User{admin: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [top] ==
               %User{profil_djvip: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [top] == %User{profil_dj: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)
      assert [top] == nil |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)
    end

    test "current month -6" do
      top = top_fixture("published", -6)

      assert [top] == %User{admin: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [top] ==
               %User{profil_djvip: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [top] == %User{profil_dj: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)
      assert [] == nil |> Top.scoped() |> Repo.all()
    end

    test "current month -24" do
      top = top_fixture("published", -24)

      assert [top] == %User{admin: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [top] ==
               %User{profil_djvip: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [top] == %User{profil_dj: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)
      assert [] == nil |> Top.scoped() |> Repo.all()
    end

    test "current month -25" do
      top = top_fixture("published", -25)

      assert [top] == %User{admin: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [top] ==
               %User{profil_djvip: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)

      assert [] == %User{profil_dj: true} |> Top.scoped() |> Repo.all()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end
  end

  describe "Counting top" do
    alias Wsdjs.Accounts.User

    test "current month to n-27 n" do
      tops =
        [
          top_fixture("counting", 0),
          top_fixture("counting", -2),
          top_fixture("counting", -3),
          top_fixture("counting", -5),
          top_fixture("counting", -6),
          top_fixture("counting", -26),
          top_fixture("counting", -27)
        ]
        |> Enum.sort()

      assert tops ==
               %User{admin: true}
               |> Top.scoped()
               |> Repo.all()
               |> Repo.preload(:songs)
               |> Enum.sort()

      assert [] == %User{profil_djvip: true} |> Top.scoped() |> Repo.all() |> Enum.sort()
      assert [] == %User{profil_dj: true} |> Top.scoped() |> Repo.all() |> Enum.sort()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end
  end

  describe "Voting top" do
    alias Wsdjs.Accounts.User

    test "current month to n-27" do
      tops =
        [
          top_fixture("voting", 0),
          top_fixture("voting", -2),
          top_fixture("voting", -3),
          top_fixture("voting", -5),
          top_fixture("voting", -6),
          top_fixture("voting", -26),
          top_fixture("voting", -27)
        ]
        |> Enum.sort()

      assert tops ==
               %User{admin: true}
               |> Top.scoped()
               |> Repo.all()
               |> Repo.preload(:songs)
               |> Enum.sort()

      assert tops ==
               %User{profil_djvip: true}
               |> Top.scoped()
               |> Repo.all()
               |> Repo.preload(:songs)
               |> Enum.sort()

      assert [] == %User{profil_dj: true} |> Top.scoped() |> Repo.all() |> Enum.sort()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end
  end

  describe "Checking top" do
    alias Wsdjs.Accounts.User

    test "current month to n-27" do
      tops = [
        top_fixture("checking", 0),
        top_fixture("checking", -2),
        top_fixture("checking", -3),
        top_fixture("checking", -5),
        top_fixture("checking", -6),
        top_fixture("checking", -26),
        top_fixture("checking", -27)
      ]

      assert tops == %User{admin: true} |> Top.scoped() |> Repo.all() |> Repo.preload(:songs)
      assert [] == %User{profil_djvip: true} |> Top.scoped() |> Repo.all()
      assert [] == %User{profil_dj: true} |> Top.scoped() |> Repo.all()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end
  end

  test "get_top!/1 returns the top with given id" do
    top = top_fixture()
    assert top == Charts.get_top!(top.id) |> Repo.preload(:songs)
  end

  test "create_top/1 with valid data creates a top" do
    user = user_fixture()
    assert {:ok, %Top{} = top} = Charts.create_top(%{due_date: Timex.today(), user_id: user.id})
    assert top.due_date == Timex.today()
  end

  test "delete_top/1 deletes the top" do
    top = top_fixture()
    assert {:ok, %Top{}} = Charts.delete_top(top)
    assert_raise Ecto.NoResultsError, fn -> Charts.get_top!(top.id) end
  end

  def user_fixture do
    {:ok, user} =
      Wsdjs.Accounts.create_user(%{email: "dummy#{System.unique_integer()}@bshit.com"})

    user
  end

  def top_fixture do
    user = user_fixture()
    {:ok, %Top{} = top} = Charts.create_top(%{due_date: Timex.today(), user_id: user.id})
    top
  end

  def top_fixture("checking", offset) do
    dt =
      Timex.today()
      |> Timex.beginning_of_month()
      |> Timex.shift(months: offset)

    user = user_fixture()
    {:ok, %Top{} = top} = Charts.create_top(%{due_date: dt, user_id: user.id})

    top
  end

  def top_fixture("voting", offset) do
    top = top_fixture("checking", offset)

    {:ok, top} = Charts.next_step(top)
    top
  end

  def top_fixture("counting", offset) do
    top = top_fixture("voting", offset)

    {:ok, top} = Charts.next_step(top)
    top
  end

  def top_fixture("published", offset) do
    top = top_fixture("counting", offset)

    {:ok, top} = Charts.next_step(top)
    top
  end
end
