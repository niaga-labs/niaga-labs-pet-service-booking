# Kilat Pet Delivery - service-booking

The booking aggregate and its state machine: create, accept, decline, pick up, deliver, cancel, rebook - plus owner pet profiles and proof-of-delivery photos. Prices each route on creation.
Jira project **KPD** - GitHub `Kilat-Pet-Delivery/service-booking` - stack **Go 1.24 - Gin - GORM - PostgreSQL - Kafka**. Global rules live in `~/.claude/`;
this file only adds what is specific here.

## Orient here first

- `.claude/memory/project_state.md` - **resume here** (`/continue` reads it, `/recap` rewrites it).
- `README.md` - how to run it. `CHANGELOG.md` - what changed.
- The workspace map: `~/Documents/kilat-pet-delivery/CLAUDE.md`.

## Commands

| Task | Command |
|---|---|
| install | `go mod download` |
| run | `go run ./cmd/server` (copy `.env.example` to `.env` first) |
| test | `go test ./...` |
| integration tests | `go test -tags integration ./...` - needs Docker; currently failing, see KPD-62 |
| lint | `gofmt -l . && go vet ./...` |
| build | `go build ./...` |
| migrate | `go run ./cmd/migrate` - applies `migrations/` and exits |

Needs the dev-infra stack: Postgres database `kilat_booking`, Kafka on `localhost:9092` -> `cd ~/Documents/dev-infra; ./dev.ps1 up kilat`.

## Conventions that differ from the global rules

- **Ticket branches and PRs** - company repo, never commit on `main` (`branch-guard` enforces it).
- **One migration path.** `migrations/` owns the schema in every environment including development, and `cmd/server` applies it at startup. There is deliberately no GORM AutoMigrate branch - that is what let six services drift (KPD-56 through KPD-61).
- Protected paths (never edited in place, see `.claude/protected-paths.txt`): `migrations/*.sql`.

## Testing

`go test ./...` runs **nothing** - all four test files are behind the `integration` tag, and that suite does not currently pass on this laptop (KPD-62). An empty default suite is not a green one.

## Where things are

- `cmd/server` - `cmd/migrate` - `internal/handler` - `internal/application/booking_service.go` the state machine - `internal/domain/{booking,pet,photo}` - `internal/events` Kafka consumer

## Worth knowing

- Publishes booking.events. A failed publish is logged and the request still returns 201, so read KPD-64 and KPD-67 before assuming events are reliable.
