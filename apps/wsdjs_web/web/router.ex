defmodule WsdjsWeb.Router do
  use WsdjsWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug WsdjsWeb.VerifySession
  end

  pipeline :browser_auth do
    plug WsdjsWeb.EnsureAuthenticated, handler_fn: :session_call
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug WsdjsWeb.VerifyHeader
  end

  scope "/", WsdjsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", HottestController, :index
    get "/search", SearchController, :index
    resources "/users", UserController, only: [:index, :show]
    resources "/hottests", HottestController, only: [:index]
    resources "/songs", SongController, only: [:show] do
      resources "/song_opinions", SongOpinionController, only: [:create]
    end
    resources "/song_opinions", SongOpinionController, only: [:delete]
    resources "/tops", TopController, only: [:index, :show, :create, :new]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", WsdjsWeb do
    pipe_through [:browser, :browser_auth]

    resources "/hottests", HottestController, only: [:create, :new]
  end

  # Other scopes may use custom stacks.
  # scope "/api", WsdjsWeb do
  #   pipe_through :api
  # end
end
