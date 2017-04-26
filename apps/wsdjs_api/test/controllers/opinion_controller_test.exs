defmodule WsdjsApi.Web.OpinionControllerTest do
  use WsdjsApi.Web.ConnCase

  alias WsdjsApi.Musics
  alias WsdjsApi.Musics.Opinion

  @create_attrs %{kind: "some kind"}
  @update_attrs %{kind: "some updated kind"}
  @invalid_attrs %{kind: nil}

  def fixture(:opinion) do
    {:ok, opinion} = Musics.create_opinion(@create_attrs)
    opinion
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, opinion_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates opinion and renders opinion when data is valid", %{conn: conn} do
    conn = post conn, opinion_path(conn, :create), opinion: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, opinion_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "kind" => "some kind"}
  end

  test "does not create opinion and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, opinion_path(conn, :create), opinion: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen opinion and renders opinion when data is valid", %{conn: conn} do
    %Opinion{id: id} = opinion = fixture(:opinion)
    conn = put conn, opinion_path(conn, :update, opinion), opinion: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, opinion_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "kind" => "some updated kind"}
  end

  test "does not update chosen opinion and renders errors when data is invalid", %{conn: conn} do
    opinion = fixture(:opinion)
    conn = put conn, opinion_path(conn, :update, opinion), opinion: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen opinion", %{conn: conn} do
    opinion = fixture(:opinion)
    conn = delete conn, opinion_path(conn, :delete, opinion)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, opinion_path(conn, :show, opinion)
    end
  end
end
