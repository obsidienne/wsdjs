# base image elixer to start with
FROM bitwalker/alpine-elixir-phoenix:latest

# install the latest phoenix 
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new-1.3.0.ez --force

ENV PORT ${PORT:-8080} 
ENV MIX_ENV prod
ENV NODE_ENV "production"
ENV CC_PHOENIX_ASSETS_DIR ${CC_PHOENIX_ASSETS_DIR}
ENV CC_PHOENIX_APP_DIR ${CC_PHOENIX_APP_DIR}
ENV DATABASE_URL ${POSTGRESQL_ADDON_URI}
EXPOSE ${PORT}

# create app folder
RUN mkdir /app
COPY . /app
WORKDIR /app

# install dependencies
RUN mix deps.get --only prod

# install node dependencies
# Run frontend build, compile, and digest assets
WORKDIR ${CC_PHOENIX_ASSETS_DIR}
RUN npm install
RUN brunch build --production

WORKDIR ${CC_PHOENIX_APP_DIR}
RUN mix ecto.migrate

WORKDIR /app
RUN mix compile
RUN phx.digest

USER default

CMD mix phx.server