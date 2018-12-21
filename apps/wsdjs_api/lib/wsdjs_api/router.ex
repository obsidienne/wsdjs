defmodule WsdjsApi.Router do
  use WsdjsApi, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WsdjsApi do
    pipe_through :api
  end
end
