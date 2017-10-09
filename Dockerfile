# base image elixer to start with
FROM bitwalker/alpine-elixir-phoenix:latest

# install the latest phoenix 
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new-1.3.0.ez --force

EXPOSE 8080
ENV PORT=8080 
ENV MIX_ENV=prod
ENV NODE_ENV="production"

# create app folder
RUN mkdir /app
COPY . /app
WORKDIR /app

# install dependencies
RUN mix deps.get --only prod

# install node dependencies
WORKDIR apps/wsdjs_web/assets
RUN npm install
RUN brunch build --production 

WORKDIR apps/wsdjs
RUN mix ecto.migrate

# Run frontend build, compile, and digest assets
RUN mix do compile, phx.digest

USER default

CMD ["mix", "phx.server"]