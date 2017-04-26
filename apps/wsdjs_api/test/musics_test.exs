defmodule WsdjsApi.MusicsTest do
  use WsdjsApi.DataCase

  alias WsdjsApi.Musics
  alias WsdjsApi.Musics.Opinion

  @create_attrs %{kind: "some kind"}
  @update_attrs %{kind: "some updated kind"}
  @invalid_attrs %{kind: nil}

  def fixture(:opinion, attrs \\ @create_attrs) do
    {:ok, opinion} = Musics.create_opinion(attrs)
    opinion
  end

  test "list_opinions/1 returns all opinions" do
    opinion = fixture(:opinion)
    assert Musics.list_opinions() == [opinion]
  end

  test "get_opinion! returns the opinion with given id" do
    opinion = fixture(:opinion)
    assert Musics.get_opinion!(opinion.id) == opinion
  end

  test "create_opinion/1 with valid data creates a opinion" do
    assert {:ok, %Opinion{} = opinion} = Musics.create_opinion(@create_attrs)
    
    assert opinion.kind == "some kind"
  end

  test "create_opinion/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Musics.create_opinion(@invalid_attrs)
  end

  test "update_opinion/2 with valid data updates the opinion" do
    opinion = fixture(:opinion)
    assert {:ok, opinion} = Musics.update_opinion(opinion, @update_attrs)
    assert %Opinion{} = opinion
    
    assert opinion.kind == "some updated kind"
  end

  test "update_opinion/2 with invalid data returns error changeset" do
    opinion = fixture(:opinion)
    assert {:error, %Ecto.Changeset{}} = Musics.update_opinion(opinion, @invalid_attrs)
    assert opinion == Musics.get_opinion!(opinion.id)
  end

  test "delete_opinion/1 deletes the opinion" do
    opinion = fixture(:opinion)
    assert {:ok, %Opinion{}} = Musics.delete_opinion(opinion)
    assert_raise Ecto.NoResultsError, fn -> Musics.get_opinion!(opinion.id) end
  end

  test "change_opinion/1 returns a opinion changeset" do
    opinion = fixture(:opinion)
    assert %Ecto.Changeset{} = Musics.change_opinion(opinion)
  end
end
