defmodule WsdjsApi.Web.Router do
  use WsdjsApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Wsdjs.VerifyHeader
  end

  scope "/api", WsdjsApi.Web do
    pipe_through :api

    resources "/ranks", RankController, except: [:index, :show, :new, :edit]
    resources "/opinions", OpinionController, except: [:new, :edit]

  end

  pipeline :api_auth do
    plug Wsdjs.EnsureAuthenticated, handler_fn: :api_call
  end
end
