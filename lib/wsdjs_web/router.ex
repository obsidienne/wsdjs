defmodule WsdjsWeb.Router do
  use WsdjsWeb, :router

  import WsdjsWeb.UserAuth
  import WsdjsWeb.AdminAuth
  import WsdjsWeb.UserProfil

  pipeline :browser do
    plug(:accepts, ["html", "text"])
    plug(:fetch_session)
    plug :fetch_live_flash
    plug :put_root_layout, {WsdjsWeb.LayoutView, :root}
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug :fetch_current_user
    plug :fetch_current_user_profil
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
    pipe_through [:browser, :require_authenticated_user]

    resources("/songs", SongController, only: [:create, :new, :delete, :update, :edit])

    live "/tops", ChartList

    resources "/tops", TopController, only: [:create, :new, :update, :delete] do
      resources("/votes", VoteController, only: [:create])
    end

    resources("/ranks", RankController, only: [:update, :delete])

    get "/users/profils", UserProfilController, :edit
    put "/users/profils", UserProfilController, :update
    resources "/users", UserController, only: [:index, :update]

    live "/library", MusicLibrary
  end

  scope "/", WsdjsWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", HomeController, :index)
    resources("/users", UserController, only: [:show])
    resources("/home", HomeController, only: [:index])
    resources("/tops", TopController, only: [:show])
    resources("/songs", SongController, only: [:show])
  end

  ## Admin routes
  use Kaffy.Routes, scope: "/admin", pipe_through: [:browser, :require_authenticated_admin]
end
