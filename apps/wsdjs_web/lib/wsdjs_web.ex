defmodule WsdjsWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use WsdjsWeb, :controller
      use WsdjsWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: WsdjsWeb
      import Plug.Conn
      import WsdjsWeb.Gettext
      alias WsdjsWeb.ApiRouteHelpers, as: ApiRoutes
      alias WsdjsWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/wsdjs_web/templates",
        namespace: WsdjsWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, get_flash: 2, view_module: 1, action_name: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import WsdjsWeb.ErrorHelpers
      import WsdjsWeb.Gettext
      alias WsdjsWeb.ApiRouteHelpers, as: ApiRoutes
      alias WsdjsWeb.Router.Helpers, as: Routes

      # Import custom helpers
      import WsdjsWeb.CloudinaryHelper
      import WsdjsWeb.SongHelper
      import WsdjsWeb.UserHelper
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import WsdjsWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
