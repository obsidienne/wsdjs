defmodule Wsdjs.Charts.ChartsTest do
  use Wsdjs.DataCase

  alias Wsdjs.Accounts.User
  alias Wsdjs.Charts
  import Wsdjs.AccountsFixtures

  describe "Charts" do
    defp top_fixture(attrs) do
      user = user_fixture()

      {:ok, %Wsdjs.Charts.Top{} = top} =
        attrs
        |> Map.put("user_id", user.id)
        |> Wsdjs.Charts.create_top()

      query = from(Wsdjs.Charts.Top, where: [id: ^top.id])
      {1, nil} = Repo.update_all(query, set: [status: "published"])

      top
    end

    test "published" do
      dt = Timex.beginning_of_month(Timex.today())

      top = top_fixture(%{"due_date" => dt})
      assert :ok == Charts.can?(%User{admin: true}, :show, top)
      assert :ok == Charts.can?(%User{profil_djvip: true}, :show, top)
      refute :ok == Charts.can?(%User{profil_dj: true}, :show, top)
      refute :ok == Charts.can?(nil, :show, top)

      top = top_fixture(%{"due_date" => Timex.shift(dt, months: -2)})
      assert :ok == Charts.can?(%User{admin: true}, :show, top)
      assert :ok == Charts.can?(%User{profil_djvip: true}, :show, top)
      refute :ok == Charts.can?(%User{profil_dj: true}, :show, top)
      refute :ok == Charts.can?(nil, :show, top)

      top = top_fixture(%{"due_date" => Timex.shift(dt, months: -5)})
      assert :ok == Charts.can?(%User{admin: true}, :show, top)
      assert :ok == Charts.can?(%User{profil_djvip: true}, :show, top)
      assert :ok == Charts.can?(%User{profil_dj: true}, :show, top)
      assert :ok == Charts.can?(nil, :show, top)

      top = top_fixture(%{"due_date" => Timex.shift(dt, months: -6)})
      assert :ok == Charts.can?(%User{admin: true}, :show, top)
      assert :ok == Charts.can?(%User{profil_djvip: true}, :show, top)
      assert :ok == Charts.can?(%User{profil_dj: true}, :show, top)
      refute :ok == Charts.can?(nil, :show, top)
    end
  end
end
