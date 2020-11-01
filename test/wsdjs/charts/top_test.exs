defmodule Wsdjs.Charts.TopTest do
  use Wsdjs.DataCase, async: true

  alias Wsdjs.Accounts
  alias Wsdjs.Charts
  alias Wsdjs.Charts.Top
  alias Wsdjs.Repo

  describe "changeset" do
    test "changeset with minimal valid attributes" do
      {:ok, dummy_id} = Wsdjs.HashID.load(999_999_999)
      changeset = Top.create_changeset(%Top{}, %{due_date: Timex.today(), user_id: dummy_id})

      assert changeset.valid?
    end

    test "top owner account must exist" do
      {:ok, dummy_id} = Wsdjs.HashID.load(999_999_999)
      top = Top.create_changeset(%Top{}, %{due_date: Timex.today(), user_id: dummy_id})

      assert {:error, %Ecto.Changeset{} = changeset} = Repo.insert(top)
      assert "does not exist" in errors_on(changeset).user
    end
  end

  describe "Published top" do
    setup :create_users

    test "current month", %{admin: admin, djvip: djvip, dj: dj} do
      top = top_fixture("published", 0)

      assert [top] == admin |> Top.scoped() |> Repo.all()
      assert [top] == djvip |> Top.scoped() |> Repo.all()
      assert [] == dj |> Top.scoped() |> Repo.all()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end

    test "current month -2", %{admin: admin, djvip: djvip, dj: dj} do
      top = top_fixture("published", -2)

      assert [top] == admin |> Top.scoped() |> Repo.all()
      assert [top] == djvip |> Top.scoped() |> Repo.all()
      assert [] == dj |> Top.scoped() |> Repo.all()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end

    test "current month -3", %{admin: admin, djvip: djvip, dj: dj} do
      top = top_fixture("published", -3)

      assert [top] == admin |> Top.scoped() |> Repo.all()
      assert [top] == djvip |> Top.scoped() |> Repo.all()
      assert [top] == dj |> Top.scoped() |> Repo.all()
      assert [top] == nil |> Top.scoped() |> Repo.all()
    end

    test "current month -5", %{admin: admin, djvip: djvip, dj: dj} do
      top = top_fixture("published", -5)

      assert [top] == admin |> Top.scoped() |> Repo.all()
      assert [top] == djvip |> Top.scoped() |> Repo.all()
      assert [top] == dj |> Top.scoped() |> Repo.all()
      assert [top] == nil |> Top.scoped() |> Repo.all()
    end

    test "current month -6", %{admin: admin, djvip: djvip, dj: dj} do
      top = top_fixture("published", -6)

      assert [top] == admin |> Top.scoped() |> Repo.all()
      assert [top] == djvip |> Top.scoped() |> Repo.all()
      assert [top] == dj |> Top.scoped() |> Repo.all()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end

    test "current month -24", %{admin: admin, djvip: djvip, dj: dj} do
      top = top_fixture("published", -24)

      assert [top] == admin |> Top.scoped() |> Repo.all()
      assert [top] == djvip |> Top.scoped() |> Repo.all()
      assert [top] == dj |> Top.scoped() |> Repo.all()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end

    test "current month -25", %{admin: admin, djvip: djvip, dj: dj} do
      top = top_fixture("published", -25)

      assert [top] == admin |> Top.scoped() |> Repo.all()
      assert [top] == djvip |> Top.scoped() |> Repo.all()
      assert [] == dj |> Top.scoped() |> Repo.all()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end
  end

  describe "Counting top" do
    setup :create_users

    test "current month to n-27 n", %{admin: admin, djvip: djvip, dj: dj} do
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
               admin
               |> Top.scoped()
               |> Repo.all()
               |> Enum.sort()

      assert [] == djvip |> Top.scoped() |> Repo.all() |> Enum.sort()
      assert [] == dj |> Top.scoped() |> Repo.all() |> Enum.sort()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end
  end

  describe "Voting top" do
    setup :create_users

    test "current month to n-27", %{admin: admin, djvip: djvip, dj: dj} do
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

      Enum.each(
        [admin, djvip],
        fn u ->
          expected =
            u
            |> Top.scoped()
            |> Repo.all()
            |> Enum.sort()

          assert tops == expected
        end
      )

      assert [] == dj |> Top.scoped() |> Repo.all()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end
  end

  describe "Checking top" do
    setup :create_users

    test "current month to n-27", %{admin: admin, djvip: djvip, dj: dj} do
      tops = [
        top_fixture("checking", 0),
        top_fixture("checking", -2),
        top_fixture("checking", -3),
        top_fixture("checking", -5),
        top_fixture("checking", -6),
        top_fixture("checking", -26),
        top_fixture("checking", -27)
      ]

      assert tops == admin |> Top.scoped() |> Repo.all()
      assert [] == djvip |> Top.scoped() |> Repo.all()
      assert [] == dj |> Top.scoped() |> Repo.all()
      assert [] == nil |> Top.scoped() |> Repo.all()
    end
  end

  test "get_top!/1 returns the top with given id" do
    top = top_fixture()
    assert top == Charts.get_top!(top.id)
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
    top |> Repo.forget(:songs, :many)
  end

  def top_fixture("checking", offset) do
    dt =
      Timex.today()
      |> Timex.beginning_of_month()
      |> Timex.shift(months: offset)

    user = user_fixture()
    {:ok, %Top{} = top} = Charts.create_top(%{due_date: dt, user_id: user.id})

    top |> Repo.forget(:songs, :many)
  end

  def top_fixture("voting", offset) do
    top = top_fixture("checking", offset)

    {:ok, top} = Charts.next_step(top)
    top |> Repo.forget(:songs, :many)
  end

  def top_fixture("counting", offset) do
    top = top_fixture("voting", offset)

    {:ok, top} = Charts.next_step(top)
    top |> Repo.forget(:songs, :many)
  end

  def top_fixture("published", offset) do
    top = top_fixture("counting", offset)

    {:ok, top} = Charts.next_step(top)
    top |> Repo.forget(:songs, :many)
  end

  defp create_users(_) do
    god = %Accounts.User{admin: true}
    {:ok, suggestor} = Wsdjs.Accounts.create_user(%{"email" => "suggestor@wsdjs.com"})
    {:ok, suggestor} = Accounts.update_user(suggestor, %{"name" => "suggestor"}, god)

    {:ok, user} = Wsdjs.Accounts.create_user(%{"email" => "user@wsdjs.com"})
    {:ok, user} = Accounts.update_user(user, %{"name" => "user"}, god)

    {:ok, dj} = Wsdjs.Accounts.create_user(%{"email" => "dj@wsdjs.com"})
    {:ok, dj} = Accounts.update_user(dj, %{"name" => "dj", "profil_dj" => true}, god)

    {:ok, djvip} = Wsdjs.Accounts.create_user(%{"email" => "djvip@wsdjs.com"})
    {:ok, djvip} = Accounts.update_user(djvip, %{"name" => "djvip", "profil_djvip" => true}, god)

    {:ok, admin} = Wsdjs.Accounts.create_user(%{"name" => "admin", "email" => "admin@wsdjs.com"})

    {:ok, admin} =
      Accounts.update_user(
        admin,
        %{"name" => "admin", "admin" => true},
        god
      )

    {:ok, suggestor: suggestor, user: user, dj: dj, djvip: djvip, admin: admin}
  end
end
