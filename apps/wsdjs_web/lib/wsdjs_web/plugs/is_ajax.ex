defmodule WsdjsWeb.IsAjax do
  @moduledoc """
  This module adds to the conn a isAjax atom based on the request headers.
  """
  import Plug.Conn

  @doc false
  def init([]), do: []

  @doc false
  def call(conn, _repo) do
    conn
    |> assign(:is_ajax, is_ajax(conn))
  end

  def is_ajax(%Plug.Conn{} = conn) do
    if get_req_header(conn, "x-requested-with") == ["XMLHttpRequest"] do
      true
    else
      false
    end
  end
end
