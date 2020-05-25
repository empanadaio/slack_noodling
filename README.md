# SlackNoodling

## Dev

```
docker-compose up -d
```

```
nix-shell
```

profit


Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Migrations

```
mix do ecto.create, ecto.migrate
mix do event_store.create, event_store.init
```

