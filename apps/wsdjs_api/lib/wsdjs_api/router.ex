defmodule WsdjsApi.Router do
  use WsdjsApi, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(WsdjsApi.VerifyHeader)
  end

  pipeline :api_auth do
    plug(WsdjsApi.EnsureAuthenticated)
  end

  scope "/api", WsdjsApi do
    pipe_through([:api, :api_auth])

    resources "/songs", SongController, only: [] do
      resources("/opinions", OpinionController, only: [:create])
      resources("/comments", CommentController, only: [:create])
      resources("/videos", VideoController, only: [:create])
    end

    resources("/users", UserController, only: []) do
      resources("/playlists", PlaylistController, only: [:index])
    end

    resources("/playlists", PlaylistController, only: []) do
      resources("/songs", PlaylistSongsController, only: [:create])
    end

    resources("/opinions", OpinionController, only: [:delete])
    resources("/comments", CommentController, only: [:delete])
    resources("/accounts", AccountController, only: [:update])
    resources("/videos", VideoController, only: [:delete])
    get("/me", AccountController, :show, as: :me)
  end

  scope "/api", WsdjsApi do
    pipe_through([:api])

    resources("/v1/mobile_config", MobileConfigController, only: [:index])
    resources("/mobile_config", MobileConfigController, only: [:index])
    resources("/radio", RadioController, only: [:index])
    get("/signin/:token", SessionController, :show, as: :signin)
    resources("/sessions", SessionController, only: [:create])

    resources "/songs", SongController, only: [] do
      resources("/comments", CommentController, only: [:index])
      resources("/videos", VideoController, only: [:index])
      resources("/opinions", OpinionController, only: [:index])
    end

    resources("/accounts", AccountController, only: [:show])
  end
end
