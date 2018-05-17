defmodule WsdjsWeb.UserListTest do
  use WsdjsWeb.FeatureCase, async: true

  import Wallaby.Query, only: [css: 2]

  test "users have names", %{session: session} do
    session
    |> visit("/users")
    |> find(css(".users-section tbody tr", count: 3))
    |> List.first()
    |> assert_has(css("a", text: "Chris"))
  end
end