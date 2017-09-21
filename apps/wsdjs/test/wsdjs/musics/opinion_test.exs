defmodule Wsdjs.OpinionTest do
  use Wsdjs.DataCase, async: true
  import Wsdjs.Factory

  alias Wsdjs.Musics

  test "Opinions are correctly summed" do
    opinions = [
      insert(:opinion, kind: "up"),
      insert(:opinion, kind: "up"),
      insert(:opinion, kind: "like"),
      insert(:opinion, kind: "like"),
      insert(:opinion, kind: "down"),
      insert(:opinion, kind: "down"),
    ]

    assert Musics.opinions_value(opinions) == 6
  end
end
