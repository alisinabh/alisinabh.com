FROM elixir:1.6.6

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mkdir /repo

RUN mix deps.get
RUN mix compile
RUN mix clean

ENV MIX_ENV=prod

VOLUME ["/repo"]

CMD ["/app/entrypoint.sh"]
