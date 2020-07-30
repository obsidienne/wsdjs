defmodule WsdjsWeb.Router do
  use WsdjsWeb, :router

  import WsdjsWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html", "text"])
    plug(:fetch_session)
    plug :fetch_live_flash
    plug :put_root_layout, {WsdjsWeb.LayoutView, :root}
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug :fetch_current_user
  end

  pipeline :browser_auth do
    plug :require_authenticated_user
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

  ## Authentication routes

  scope "/", WsdjsWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", WsdjsWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", WsdjsWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  ## Application routes

  scope "/", WsdjsWeb do
    pipe_through([:browser, :browser_auth])

    resources("/songs", SongController, only: [:index, :create, :new, :delete, :update, :edit]) do
      resources("/videos", SongVideosController, only: [:index, :new, :create, :delete])
    end

    resources("/suggestions", SuggestionController, only: [:create, :new])

    resources "/tops", TopController, only: [:index, :create, :new, :update, :delete] do
      resources("/votes", VoteController, only: [:create])
    end

    get("/tops/:id/stats", TopController, :stat, as: :top_stat)

    resources("/ranks", RankController, only: [:update, :delete])
    resources("/events", EventController)

    resources "/users", UserController, only: [:index, :edit, :update] do
      resources("/playlists", PlaylistController, only: [:new, :create, :index])
    end

    live "/paginate-users", PaginateUsersLive

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
    resources("/tops", TopController, only: [:show])

    resources("/songs", SongController, only: [:show]) do
      resources("/opinions", OpinionController, only: [:index])
    end

    resources("/api/v1/now_playing", NowPlayingController, only: [:index])
    resources("/api/now_playing", NowPlayingController, only: [:index])
  end

  scope "/api", WsdjsWeb.Api, as: :api do
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

  scope "/api", WsdjsWeb.Api, as: :api do
    pipe_through([:api])

    resources("/v1/mobile_config", MobileConfigController, only: [:index])
    resources("/mobile_config", MobileConfigController, only: [:index])
    resources("/radio", RadioController, only: [:index])

    resources "/songs", SongController, only: [] do
      resources("/comments", CommentController, only: [:index])
      resources("/videos", VideoController, only: [:index])
      resources("/opinions", OpinionController, only: [:index])
    end

    resources("/accounts", AccountController, only: [:show])
  end
end
