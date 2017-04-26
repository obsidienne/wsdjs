defmodule WsdjsApi.TrendingsTest do
  use WsdjsApi.DataCase

  alias WsdjsApi.Trendings
  alias WsdjsApi.Trendings.Rank

  @create_attrs %{bonus: 42, likes: 42, position: 42, votes: 42}
  @update_attrs %{bonus: 43, likes: 43, position: 43, votes: 43}
  @invalid_attrs %{bonus: nil, likes: nil, position: nil, votes: nil}

  def fixture(:rank, attrs \\ @create_attrs) do
    {:ok, rank} = Trendings.create_rank(attrs)
    rank
  end

  test "list_ranks/1 returns all ranks" do
    rank = fixture(:rank)
    assert Trendings.list_ranks() == [rank]
  end

  test "get_rank! returns the rank with given id" do
    rank = fixture(:rank)
    assert Trendings.get_rank!(rank.id) == rank
  end

  test "create_rank/1 with valid data creates a rank" do
    assert {:ok, %Rank{} = rank} = Trendings.create_rank(@create_attrs)
    
    assert rank.bonus == 42
    assert rank.likes == 42
    assert rank.position == 42
    assert rank.votes == 42
  end

  test "create_rank/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Trendings.create_rank(@invalid_attrs)
  end

  test "update_rank/2 with valid data updates the rank" do
    rank = fixture(:rank)
    assert {:ok, rank} = Trendings.update_rank(rank, @update_attrs)
    assert %Rank{} = rank
    
    assert rank.bonus == 43
    assert rank.likes == 43
    assert rank.position == 43
    assert rank.votes == 43
  end

  test "update_rank/2 with invalid data returns error changeset" do
    rank = fixture(:rank)
    assert {:error, %Ecto.Changeset{}} = Trendings.update_rank(rank, @invalid_attrs)
    assert rank == Trendings.get_rank!(rank.id)
  end

  test "delete_rank/1 deletes the rank" do
    rank = fixture(:rank)
    assert {:ok, %Rank{}} = Trendings.delete_rank(rank)
    assert_raise Ecto.NoResultsError, fn -> Trendings.get_rank!(rank.id) end
  end

  test "change_rank/1 returns a rank changeset" do
    rank = fixture(:rank)
    assert %Ecto.Changeset{} = Trendings.change_rank(rank)
  end
end
