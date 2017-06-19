defmodule Wsdjs.Router do
  use Wsdjs, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Wsdjs.VerifySession
  end

  pipeline :browser_auth do
    plug Wsdjs.EnsureAuthenticated, handler_fn: :session_call
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Wsdjs.VerifyHeader
  end

  pipeline :api_auth do
    plug Wsdjs.EnsureAuthenticated, handler_fn: :api_call
  end

  if Mix.env == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

  scope "/", Wsdjs do
    pipe_through [:browser, :browser_auth]

    resources "/songs", SongController, only: [:index, :create, :new]
    resources "/song_opinions", SongOpinionController, only: [:delete]
    resources "/tops", TopController, only: [:create, :new, :update] do
      resources "/votes", VoteController, only: [:create]
    end
    resources "/ranks", RankController, only: [:update]
    resources "/sessions", SessionController, only: [:delete]
  end


  scope "/", Wsdjs do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index
    get "/search", SearchController, :index
    resources "/users", UserController, only: [:index, :show, :edit, :create, :update]
    resources "/home", HomeController, only: [:index]
    resources "/songs", SongController, only: [:show]
    resources "/tops", TopController, only: [:index, :show]
    resources "/sessions", SessionController, only: [:new, :create]
    get "/signin/:token", SessionController, :show, as: :signin
  end

  scope "/api", as: :api, alias: :Wsdjs do
    pipe_through [:api, :api_auth]

    scope "/v1", alias: API.V1 do
      resources "/songs", SongController, only: [] do
        resources "/opinions", OpinionController, only: [:create]
        resources "/comments", CommentController, only: [:create]
      end
      resources "/options", OpinionController, only: [:delete]
    end
  end

  scope "/api", as: :api, alias: :Wsdjs do
    pipe_through [:api]

    resources "/now_playing", NowPlayingController, only: [:index]
    resources "/mobile_config", MobileConfigController, only: [:index]
  end
end
