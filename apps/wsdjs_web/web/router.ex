defmodule WsdjsWeb.Router do
  use WsdjsWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WsdjsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", HottestController, :index
    resources "/accounts", AccountController, only: [:index, :show]
    resources "/hottests", HottestController, only: [:index, :show]
    resources "/songs", SongController, only: [:show]
    resources "/tops", TopController, only: [:index, :show]
    resources "/accounts", AccountController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", WsdjsWeb do
  #   pipe_through :api
  # end
end
