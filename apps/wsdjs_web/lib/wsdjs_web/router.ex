defmodule WsdjsWeb.Router do
  use WsdjsWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "text"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug WsdjsWeb.VerifySession
    plug WsdjsWeb.IdentifyUa
  end

  pipeline :browser_auth do
    plug WsdjsWeb.EnsureAuthenticated, handler_fn: :session_call
  end

  pipeline :ensure_admin do
    plug WsdjsWeb.EnsureAdmin, handler_fn: :admin_call
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug WsdjsWeb.VerifyHeader
  end

  pipeline :api_auth do
    plug WsdjsWeb.EnsureAuthenticated, handler_fn: :api_call
  end

  if Mix.env == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

  scope "/", WsdjsWeb do
    pipe_through [:browser, :browser_auth]

    resources "/songs", SongController, only: [:index, :create, :new, :delete, :edit, :update]
    resources "/suggestions", SuggestionController, only: [:create, :new]
    resources "/song_opinions", SongOpinionController, only: [:delete]
    resources "/tops", TopController, only: [:create, :new, :update, :delete] do
      resources "/votes", VoteController, only: [:create]
    end
    get "/tops/:id/stats", TopController, :stat, as: :top_stat

    resources "/ranks", RankController, only: [:update, :delete]
    resources "/sessions", SessionController, only: [:delete]
    resources "/users", UserController, only: [:edit, :update]
  end

  scope "/", WsdjsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index
    get "/search", SearchController, :index
    resources "/users", UserController, only: [:show]
    resources "/home", HomeController, only: [:index]
    resources "/songs", SongController, only: [:show]
    resources "/tops", TopController, only: [:index, :show]
    resources "/sessions", SessionController, only: [:new, :create]
    resources "/registrations", RegistrationController, only: [:new, :create]
    get "/signin/:token", SessionController, :show, as: :signin
    get "/invited/:token", InvitedController, :show, as: :invited
    resources "/invitations", InvitationController, only: [:new, :create]
  end

  scope "/admin", as: :admin, alias: :'WsdjsWeb.Admin' do
    pipe_through [:browser, :browser_auth, :ensure_admin]

    resources "/users", UserController
    resources "/invitations", InvitationController, only: [:delete, :update]
  end

  scope "/api", as: :api, alias: :'WsdjsWeb' do
    pipe_through [:api, :api_auth]

    scope "/v1", alias: Api.V1 do
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

  scope "/api", as: :api, alias: :'WsdjsWeb' do
    pipe_through [:api]

    scope "/", alias: Api do
      resources "/now_playing", NowPlayingController, only: [:index]
      resources "/mobile_config", MobileConfigController, only: [:index]
    end

    scope "/v1", alias: Api.V1 do
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

  scope "/", as: :api, alias: :'WsdjsWeb' do
    pipe_through [:api]

    scope "/", alias: Api do
      get "/.well-known/:page", StaticController, :show
    end
  end
end
