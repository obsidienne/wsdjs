defmodule Wsdjs.PolicyTest do
  use Wsdjs.DataCase

  alias Wsdjs.Charts.Policy
  alias Wsdjs.Accounts.User

  import Wsdjs.Factory

  describe "policy" do
    test "published" do
      dt = Timex.beginning_of_month(Timex.today)

      top = insert(:top, %{status: "published", due_date: dt})
      assert :ok == Policy.can?(%User{admin: :true}, :show, top)
      assert :ok == Policy.can?(%User{profil_djvip: true}, :show, top)
      refute :ok == Policy.can?(%User{profil_dj: true}, :show, top)
      refute :ok == Policy.can?(nil, :show, top)

      top = insert(:top, %{status: "published", due_date: Timex.shift(dt, months: -2)})
      assert :ok == Policy.can?(%User{admin: :true}, :show, top)
      assert :ok == Policy.can?(%User{profil_djvip: true}, :show, top)
      refute :ok == Policy.can?(%User{profil_dj: true}, :show, top)
      refute :ok == Policy.can?(nil, :show, top)

      top = insert(:top, %{status: "published", due_date: Timex.shift(dt, months: -5)})
      assert :ok == Policy.can?(%User{admin: :true}, :show, top)
      assert :ok == Policy.can?(%User{profil_djvip: true}, :show, top)
      assert :ok == Policy.can?(%User{profil_dj: true}, :show, top)
      assert :ok == Policy.can?(nil, :show, top)

      top = insert(:top, %{status: "published", due_date: Timex.shift(dt, months: -6)})
      assert :ok == Policy.can?(%User{admin: :true}, :show, top)
      assert :ok == Policy.can?(%User{profil_djvip: true}, :show, top)
      assert :ok == Policy.can?(%User{profil_dj: true}, :show, top)
      refute :ok == Policy.can?(nil, :show, top)
    end
  end
end
