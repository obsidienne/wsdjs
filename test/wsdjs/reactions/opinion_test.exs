defmodule Brididi.Reactions.OpinionTest do
  use Brididi.DataCase, async: true

  test "Opinions are correctly summed" do
    opinions = [
      %{kind: "up"},
      %{kind: "up"},
      %{kind: "down"},
      %{kind: "down"},
      %{kind: "like"},
      %{kind: "like"}
    ]

    assert Brididi.Reactions.Opinions.opinions_value(opinions) == 6
  end
end
