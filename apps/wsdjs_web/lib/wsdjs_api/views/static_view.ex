defmodule WsdjsApi.StaticView do
  use WsdjsApi, :view

  def render("show.json", %{"page" => "apple-app-site-association"}) do
    %{
      applinks: %{
        details: [
          %{
            appID: "62F84BCNF5.com.radiowcs",
            paths: ["*/api/v1/*"]
          },
          %{
            appID: "CJS9597AL5.com.radiowcs",
            paths: ["*/api/v1/*"]
          }
        ],
        apps: []
      }
    }
  end
end
