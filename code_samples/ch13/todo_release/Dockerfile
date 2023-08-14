ARG ELIXIR="1.15.4"
ARG ERLANG="26.0.2"
ARG DEBIAN="bookworm-20230612-slim"
ARG OS="debian-${DEBIAN}"
FROM "hexpm/elixir:${ELIXIR}-erlang-${ERLANG}-${OS}" as builder

WORKDIR /todo
ENV MIX_ENV="prod"

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config
COPY lib lib

RUN mix deps.get --only prod
RUN mix release


FROM debian:${DEBIAN}

WORKDIR "/todo"

RUN apt-get update -y && apt-get install -y openssl locales

COPY \
  --from=builder \
  --chown=nobody:root \
  /todo/_build/prod/rel/todo ./

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

CMD ["/todo/bin/todo", "start_iex"]
