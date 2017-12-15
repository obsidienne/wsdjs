defmodule WsdjsWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :wsdjs_web

  plug Corsica, origins: ["http://radiowcs.com", "http://www.radiowcs.com"],
                allow_headers: ["Authorization", "Origin", "user-token", "Content-Type", "X-Requested-With"],
                allow_methods: ["GET"],
                allow_credentials: true

  socket "/socket", WsdjsWeb.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :wsdjs_web, gzip: true, brotli: true,
    only: ~w(css fonts images js favicon.ico robots.txt),
    cache_control_for_vsn_requests: "public, max-age=31536000, immutable"

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_wsdjs_web_key",
    signing_salt: "TqBKF7iB",
    encryption_salt: "fVT6E68C",
    max_age: 94_608_000  # 60*60*24*365*3 => 3 years

  plug WsdjsWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      secret_key_base = System.get_env("SECRET_KEY_BASE") || raise "expected the SECRET_KEY_BASE environment variable to be set"
      host = System.get_env("WSDJS_URL") || "www.worldswingdjs.com"

      config = config
      |> Keyword.put(:http, [:inet6, port: port])
      |> Keyword.put(:secret_key_base, secret_key_base)
      |> Keyword.put(:url, [host: host, port: 443, scheme: "https"])

      {:ok, config}
    else
      {:ok, config}
    end
  end
end
