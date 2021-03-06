defmodule WsdjsWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :wsdjs_web

  plug(
    Corsica,
    origins: ["http://radiowcs.com", "http://www.radiowcs.com"],
    allow_headers: ["Authorization", "Origin", "user-token", "Content-Type", "X-Requested-With"],
    allow_methods: ["GET"],
    allow_credentials: true
  )

  socket "/socket", WsdjsWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug(
    Plug.Static,
    at: "/",
    from: :wsdjs_web,
    gzip: true,
    brotli: true,
    only: ~w(css fonts images js favicon.ico robots.txt),
    cache_control_for_vsn_requests: "public, max-age=31536000, immutable"
  )

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
    json_decoder: Phoenix.json_library()

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug(
    Plug.Session,
    store: :cookie,
    key: "_wsdjs_web_key",
    signing_salt: "aKlWayK3",
    encryption_salt: "Vj3tqnh8",
    # 60*60*24*365*3 => 3 years
    max_age: 94_608_000
  )

  plug(WsdjsWeb.Router)
end
