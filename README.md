# KM

Dependencies needed:

- Elixir/Erlang
- Docker

## Setup

Datbase Setup:

- `docker pull pgvector/pgvector:pg16`
- `docker run -d --name pgvector -p 5432:5432 -e POSTGRES_PASSWORD=password pgvector/pgvector:pg16`

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
