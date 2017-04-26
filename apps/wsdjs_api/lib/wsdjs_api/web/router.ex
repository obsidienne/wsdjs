defmodule WsdjsApi.Web.Router do
  use WsdjsApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WsdjsApi.Web do
    pipe_through :api

    resources "/ranks", RankController, except: [:new, :edit]

  end
end
