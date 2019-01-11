defmodule WsdjsProxy.Router do
  use WsdjsProxy, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WsdjsProxy do
    pipe_through :api
  end
end
