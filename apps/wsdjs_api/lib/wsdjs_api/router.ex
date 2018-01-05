defmodule WsdjsApi.Router do
  use WsdjsApi, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug WsdjsApi.VerifyHeader
  end

  pipeline :api_auth do
    plug WsdjsApi.EnsureAuthenticated, handler_fn: :api_call
  end

  scope "/", WsdjsApi do
    pipe_through [:api, :api_auth]

    scope "/v1", V1 do
      resources "/songs", SongController, only: [] do
        resources "/opinions", OpinionController, only: [:create]
        resources "/comments", CommentController, only: [:create]
        resources "/videos", VideoController, only: [:create]
      end
      resources "/opinions", OpinionController, only: [:delete]
      resources "/comments", CommentController, only: [:delete]
      resources "/accounts", AccountController, only: [:update]

      get "/me", AccountController, :show, as: :me
    end
  end

  scope "/", WsdjsApi do
    pipe_through [:api]

    resources "/now_playing", NowPlayingController, only: [:index]
    resources "/mobile_config", MobileConfigController, only: [:index]

    scope "/v1", V1 do
      resources "/now_playing", NowPlayingController, only: [:index]
      resources "/mobile_config", MobileConfigController, only: [:index]
      get "/signin/:token", SessionController, :show, as: :signin
      resources "/sessions", SessionController, only: [:create]
      resources "/songs", SongController, only: [] do
        resources "/comments", CommentController, only: [:index]
        resources "/videos", VideoController, only: [:index]
        resources "/opinions", OpinionController, only: [:index]
      end
      resources "/accounts", AccountController, only: [:show]
    end
  end

  scope "/", WsdjsApi do
    pipe_through [:api]

    get "/.well-known/:page", StaticController, :show
  end
end
