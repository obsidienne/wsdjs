# from https://gist.github.com/bsedat/16cb74ebc8ab0ed61ac598a129b0a7ea
FROM elixir:1.5.1 as asset-builder-mix-getter

ENV HOME=/opt/app

RUN mix do local.hex --force, local.rebar --force
# Cache elixir deps
COPY config/ $HOME/config/
COPY mix.exs mix.lock $HOME/
COPY apps/wsdjs_web/mix.exs $HOME/apps/wsdjs_web/
COPY apps/wsdjs_web/config/ $HOME/apps/wsdjs_web/config/

WORKDIR $HOME/apps/wsdjs_web
RUN mix deps.get

########################################################################
FROM node:6 as asset-builder

ENV HOME=/opt/app
WORKDIR $HOME

COPY --from=asset-builder-mix-getter $HOME/deps $HOME/deps

WORKDIR $HOME/apps/wsdjs_web/assets
COPY apps/wsdjs_web/assets/ ./
RUN yarn install
RUN ./node_modules/.bin/brunch build --production

########################################################################
FROM bitwalker/alpine-elixir:1.5.1 as releaser

ENV HOME=/opt/app

ARG ERLANG_COOKIE
ENV ERLANG_COOKIE $ERLANG_COOKIE

# dependencies for comeonin
RUN apk add --no-cache build-base cmake

# Install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# Cache elixir deps
COPY config/ $HOME/config/
COPY mix.exs mix.lock $HOME/

# Copy umbrella app config + mix.exs files
COPY apps/wsdjs/mix.exs $HOME/apps/wsdjs/
COPY apps/wsdjs/config/ $HOME/apps/wsdjs/config/

COPY apps/wsdjs_jobs/mix.exs $HOME/apps/wsdjs_jobs/
COPY apps/wsdjs_jobs/config/ $HOME/apps/wsdjs_jobs/config/

COPY apps/wsdjs_web/mix.exs $HOME/apps/wsdjs_web/
COPY apps/wsdjs_web/config/ $HOME/apps/wsdjs_web/config/

ENV MIX_ENV=prod
RUN mix do deps.get --only $MIX_ENV, deps.compile

COPY . $HOME/

# Digest precompiled assets
COPY --from=asset-builder $HOME/apps/wsdjs_web/priv/static/ $HOME/apps/wsdjs_web/priv/static/

WORKDIR $HOME/apps/wsdjs_web
RUN mix phx.digest

# Release
WORKDIR $HOME
RUN mix release --env=$MIX_ENV --verbose

########################################################################
FROM alpine:3.6

ENV LANG=en_US.UTF-8 \
    HOME=/opt/app/ \
    TERM=xterm

ENV RADIOWCS_PLATFORM_VERSION=0.1.0

RUN apk add --no-cache ncurses-libs openssl

EXPOSE 8080
ENV PORT=8080 \
    MIX_ENV=prod \
    REPLACE_OS_VARS=true \
    SHELL=/bin/sh

COPY --from=releaser $HOME/_build/prod/rel/radiowcs_platform/releases/$RADIOWCS_PLATFORM_VERSION/radiowcs_platform.tar.gz $HOME
WORKDIR $HOME
RUN tar -xzf radiowcs_platform.tar.gz

ENTRYPOINT ["/opt/app/bin/radiowcs_platform"]
CMD ["foreground"]