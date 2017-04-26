defmodule WsdjsApi.Web.RankControllerTest do
  use WsdjsApi.Web.ConnCase

  alias WsdjsApi.Trendings
  alias WsdjsApi.Trendings.Rank

  @create_attrs %{bonus: 42, likes: 42, position: 42, votes: 42}
  @update_attrs %{bonus: 43, likes: 43, position: 43, votes: 43}
  @invalid_attrs %{bonus: nil, likes: nil, position: nil, votes: nil}

  def fixture(:rank) do
    {:ok, rank} = Trendings.create_rank(@create_attrs)
    rank
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, rank_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates rank and renders rank when data is valid", %{conn: conn} do
    conn = post conn, rank_path(conn, :create), rank: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, rank_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "bonus" => 42,
      "likes" => 42,
      "position" => 42,
      "votes" => 42}
  end

  test "does not create rank and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, rank_path(conn, :create), rank: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen rank and renders rank when data is valid", %{conn: conn} do
    %Rank{id: id} = rank = fixture(:rank)
    conn = put conn, rank_path(conn, :update, rank), rank: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, rank_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "bonus" => 43,
      "likes" => 43,
      "position" => 43,
      "votes" => 43}
  end

  test "does not update chosen rank and renders errors when data is invalid", %{conn: conn} do
    rank = fixture(:rank)
    conn = put conn, rank_path(conn, :update, rank), rank: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen rank", %{conn: conn} do
    rank = fixture(:rank)
    conn = delete conn, rank_path(conn, :delete, rank)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, rank_path(conn, :show, rank)
    end
  end
end
