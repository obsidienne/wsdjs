defmodule WsdjsWeb.Router do
  use WsdjsWeb, :router

  pipeline :browser do
    plug(:accepts, ["html", "text"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(WsdjsWeb.VerifySession)
    plug(WsdjsWeb.IdentifyUa)
    plug(WsdjsWeb.IsAjax)
  end

  pipeline :browser_auth do
    plug(WsdjsWeb.EnsureAuthenticated)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(WsdjsApi.VerifyHeader)
  end

  pipeline :api_auth do
    plug(WsdjsApi.EnsureAuthenticated)
  end

  if Mix.env() == :dev do
    forward("/sent_emails", Bamboo.SentEmailViewerPlug)
  end

  scope "/", WsdjsWeb do
    pipe_through([:browser, :browser_auth])

    resources("/songs", SongController, only: [:index, :create, :new, :delete, :edit, :update]) do
      resources("/videos", SongVideosController, only: [:index])
    end

    resources("/suggestions", SuggestionController, only: [:create, :new])
    resources("/song_opinions", SongOpinionController, only: [:delete])

    resources "/tops", TopController, only: [:create, :new, :update, :delete] do
      resources("/votes", VoteController, only: [:create])
    end

    get("/tops/:id/stats", TopController, :stat, as: :top_stat)

    resources("/ranks", RankController, only: [:update, :delete])
    resources("/sessions", SessionController, only: [:delete])
    resources("/events", EventController)

    resources "/users", UserController, only: [:index, :edit, :update] do
      resources("/playlists", PlaylistController, only: [:new, :create, :index])
    end

    resources("/user-params", UserParamsController, only: [:show])

    resources("/playlists", PlaylistController, only: [:show, :edit, :delete, :update]) do
      resources("/songs", PlaylistSongsController, only: [:create])
      resources("/search", PlaylistSearchAddController, only: [:index])
    end
  end

  scope "/", WsdjsWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", HomeController, :index)
    get("/radio", RadioController, :show)
    resources("/users", UserController, only: [:show])
    resources("/home", HomeController, only: [:index])
    resources("/tops", TopController, only: [:index, :show])
    resources("/sessions", SessionController, only: [:new, :create])
    resources("/registrations", RegistrationController, only: [:new, :create])
    get("/signin/:token", SessionController, :show, as: :signin)

    resources("/songs", SongController, only: [:show]) do
      resources("/opinions", OpinionController, only: [:index])
    end
  end

  scope "/api", as: :api, alias: :WsdjsApi do
    pipe_through([:api, :api_auth])

    scope "/v1", V1 do
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
  end

  scope "/api", as: :api, alias: :WsdjsApi do
    pipe_through([:api])

    scope "/" do
      resources("/now_playing", NowPlayingController, only: [:index])
      resources("/mobile_config", MobileConfigController, only: [:index])
    end

    scope "/v1", V1 do
      resources("/now_playing", NowPlayingController, only: [:index])
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

  scope "/", as: :api, alias: :WsdjsApi do
    pipe_through([:api])

    scope "/" do
      get("/.well-known/:page", StaticController, :show)
    end
  end
end
