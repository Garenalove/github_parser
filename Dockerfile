FROM elixir:1.10

RUN apt-get update && apt-get install -y --no-install-recommends locales \
    && export LANG=en_US.UTF-8 \
    && echo $LANG UTF-8 > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=$LANG

RUN mix local.hex --force && \
    mix local.rebar --force