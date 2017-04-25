web: cd apps/master_proxy && MIX_ENV=prod mix phx.server
dev: cd apps/master_proxy && mix phx.server
release: POOL_SIZE=1 mix ecto.heroku_init
