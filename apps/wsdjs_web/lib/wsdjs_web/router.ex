defmodule WsdjsWeb.Router do
  use WsdjsWeb, :router

  pipeline :browser do
    plug(:accepts, ["html", "text"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(WsdjsWeb.VerifySession)
    plug(WsdjsWeb.IsAjax)
  end

  pipeline :browser_auth do
    plug(WsdjsWeb.EnsureAuthenticated)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  if Mix.env() == :dev do
    forward("/sent_emails", Bamboo.SentEmailViewerPlug)
  end

  scope "/", WsdjsWeb do
    pipe_through([:browser, :browser_auth])

    resources("/songs", SongController, only: [:index, :create, :new, :delete, :update]) do
      resources("/videos", SongVideosController, only: [:index, :new, :create, :delete])
      get "/edit", SongActionsController, :edit
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
      resources("/songs", PlaylistSongsController, only: [:create, :delete, :update])
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

  scope "/", as: :api, alias: :WsdjsApi do
    pipe_through([:api])

    scope "/" do
      get("/.well-known/:page", StaticController, :show)
    end
  end
end
