defmodule Wsdjs.Charts.PolicyTest do
  use Wsdjs.DataCase

  alias Wsdjs.Charts.Policy
  alias Wsdjs.Accounts.User

  describe "policy" do
    defp top_fixture(attrs) do
      {:ok, %User{} = user} = Wsdjs.Accounts.create_user(%{email: "dummy#{System.unique_integer()}@bshit.com"})

      {:ok, %Wsdjs.Charts.Top{} = top} = attrs
      |> Map.put(:user_id, user.id)
      |> Wsdjs.Charts.create_top()

      query = from Wsdjs.Charts.Top, where: [id: ^top.id]
      {1, nil} = Repo.update_all(query, set: [status: "published"])

      top
    end

    test "published" do
      dt = Timex.beginning_of_month(Timex.today)

      top = top_fixture(%{due_date: dt})
      assert :ok == Policy.can?(%User{admin: :true}, :show, top)
      assert :ok == Policy.can?(%User{profil_djvip: true}, :show, top)
      refute :ok == Policy.can?(%User{profil_dj: true}, :show, top)
      refute :ok == Policy.can?(nil, :show, top)

      top = top_fixture(%{due_date: Timex.shift(dt, months: -2)})
      assert :ok == Policy.can?(%User{admin: :true}, :show, top)
      assert :ok == Policy.can?(%User{profil_djvip: true}, :show, top)
      refute :ok == Policy.can?(%User{profil_dj: true}, :show, top)
      refute :ok == Policy.can?(nil, :show, top)

      top = top_fixture(%{due_date: Timex.shift(dt, months: -5)})
      assert :ok == Policy.can?(%User{admin: :true}, :show, top)
      assert :ok == Policy.can?(%User{profil_djvip: true}, :show, top)
      assert :ok == Policy.can?(%User{profil_dj: true}, :show, top)
      assert :ok == Policy.can?(nil, :show, top)

      top = top_fixture(%{due_date: Timex.shift(dt, months: -6)})
      assert :ok == Policy.can?(%User{admin: :true}, :show, top)
      assert :ok == Policy.can?(%User{profil_djvip: true}, :show, top)
      assert :ok == Policy.can?(%User{profil_dj: true}, :show, top)
      refute :ok == Policy.can?(nil, :show, top)
    end
  end
end
