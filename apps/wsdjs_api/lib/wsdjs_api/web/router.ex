defmodule WsdjsApi.Web.Router do
  use WsdjsApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WsdjsApi.Web do
    pipe_through :api
  end
end
