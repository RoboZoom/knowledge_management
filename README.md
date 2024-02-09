# KM

Dependencies needed:

- Elixir/Erlang
- Docker

## Setup

Database Setup:

- `docker pull pgvector/pgvector:pg16`
- `docker run -d --name pgvector -p 5432:5432 -e POSTGRES_PASSWORD=password pgvector/pgvector:pg16`
- Run `mix setup` to install application dependencies and configure the database

Run the Server:

- `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Release Information

- Build the Release: `mix release`
- Build the Image: `docker build --tag=b11:amd --platform linux/amd64 .`
- Compress the Image: `docker save bravo11_chester:latest | gzip > bravo11_chester_latest.tar.gz`