defmodule WsdjsWeb.IsAjax do
  @moduledoc """
  This module adds to the conn a isAjax atom based on the request headers.
  """
  import Plug.Conn

  @doc false
  def init([]), do: []

  @doc false
  def call(conn, _repo) do
    if get_req_header(conn, "x-requested-with") == ["XMLHttpRequest"] do
      conn
      |> assign(:is_ajax, true)
      |> assign(:ajax_suffix, "_ajax")
    else
      conn
    end
  end
end
