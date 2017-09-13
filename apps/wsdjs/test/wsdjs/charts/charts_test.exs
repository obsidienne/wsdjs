defmodule Wsdjs.ChartsTest do
  use Wsdjs.DataCase
  import Wsdjs.Factory

  alias Wsdjs.Charts
  alias Wsdjs.Charts.Top

  test "On create TOP, Song are selected according to month" do
    dt = Timex.beginning_of_month(Timex.now)
    dtend = Timex.end_of_month(Timex.now)
    user = insert(:user, profil_djvip: true)

    insert(:song, %{inserted_at: Timex.to_datetime(Timex.shift(dt, seconds: -1))})
    insert(:song, %{inserted_at: Timex.shift(dtend, seconds: 1)})
    song_in = [
      insert(:song, %{inserted_at: Timex.shift(dt, microseconds: 1), user: user}),
      insert(:song, %{inserted_at: Timex.shift(dt, days: 1, microseconds: 1), user: user}),
      insert(:song, %{inserted_at: dtend, user: user}),
    ]

    user = insert(:user, %{admin: true})
    {:ok, %Top{} = top} = Charts.create_top(%{"due_date": Timex.today, user_id: user.id})
    assert Enum.count(top.songs) == 3
    assert song_in == top.songs |> Repo.preload(:user)
  end
end
