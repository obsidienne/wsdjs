defmodule WsdjsWeb.Api.StaticView do
  use WsdjsWeb, :view

  def render("show.json", %{"page" => "apple-app-site-association"}) do
    %{
      applinks: %{
        details: [
          %{
            appID: "62F84BCNF5.com.radiowcs",
            paths: ["*/api/v1/*"]
          }
        ],
        apps: []
      }
    }
  end
end
