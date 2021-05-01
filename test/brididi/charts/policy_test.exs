defmodule Brididi.Charts.ChartsTest do
  use Brididi.DataCase

  alias Brididi.Accounts.User
  alias Brididi.Charts
  import Brididi.AccountsFixtures

  describe "Charts" do
    defp top_fixture(attrs) do
      user = user_fixture()

      {:ok, %Brididi.Charts.Top{} = top} =
        attrs
        |> Map.put("user_id", user.id)
        |> Brididi.Charts.create_top()

      query = from(Brididi.Charts.Top, where: [id: ^top.id])
      {1, nil} = Repo.update_all(query, set: [status: "published"])

      top
    end

    test "published" do
      dt_start = Date.beginning_of_month(Date.utc_today())
      dt_end = Date.end_of_month(Date.utc_today())

      top = top_fixture(%{"start_date" => dt_start, "end_date" => dt_end})
      assert :ok == Charts.can?(%User{admin: true}, :show, top)
      assert :ok == Charts.can?(%User{profil_djvip: true}, :show, top)
      refute :ok == Charts.can?(%User{profil_dj: true}, :show, top)
      refute :ok == Charts.can?(nil, :show, top)

      top =
        top_fixture(%{
          "start_date" => Timex.shift(dt_start, months: -2),
          "end_date" => Timex.shift(dt_end, months: -2)
        })

      assert :ok == Charts.can?(%User{admin: true}, :show, top)
      assert :ok == Charts.can?(%User{profil_djvip: true}, :show, top)
      refute :ok == Charts.can?(%User{profil_dj: true}, :show, top)
      refute :ok == Charts.can?(nil, :show, top)

      top =
        top_fixture(%{
          "start_date" => Timex.shift(dt_start, months: -5),
          "end_date" => Timex.shift(dt_end, months: -5)
        })

      assert :ok == Charts.can?(%User{admin: true}, :show, top)
      assert :ok == Charts.can?(%User{profil_djvip: true}, :show, top)
      assert :ok == Charts.can?(%User{profil_dj: true}, :show, top)
      assert :ok == Charts.can?(nil, :show, top)

      top =
        top_fixture(%{
          "start_date" => Timex.shift(dt_start, months: -6),
          "end_date" => Timex.shift(dt_end, months: -6)
        })

      assert :ok == Charts.can?(%User{admin: true}, :show, top)
      assert :ok == Charts.can?(%User{profil_djvip: true}, :show, top)
      assert :ok == Charts.can?(%User{profil_dj: true}, :show, top)
      refute :ok == Charts.can?(nil, :show, top)
    end
  end
end
