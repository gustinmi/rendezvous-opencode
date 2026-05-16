# Commute Tracker

Rendezvous Service will facilitate easy meetups on crossings of our daily commute paths.
Service records locations and proposes rendezvous points to users with similar commutes or commutes crossings. This service should facilitate p2p exchange of goods, books, services and would encourage reuse instead of purchasing new stuff. 

Modules:

- Backend that records user commute locations, stores them in a database, and determines whether two users' commutes intersect.
- Simulation Frontend where clicks on openstreet map record location into database.

## Prerequisites

- Python 3.12+
- PostgreSQL with H3 extension (running on `localhost:5432`)
- `CODEPLAIN_API_KEY` environment variable set

## Quick start

### 1. Render the code

```bash
codeplain commute-backend.plain
```

Generated code lands in `plain_modules/commute-backend/`.

### 2. Install dependencies

```bash
cd plain_modules/commute-backend
pip install -r requirements.txt
cd ../..
```

### 3. Run the server

```bash
cd plain_modules/commute-backend
python commute_backend.py
```

The server starts on the port configured at the top of `app.py` (default `8080`).

## Testing with curl

### Ingest a commute point

Replace `<id>` with a user ID and `<ISO-8601>` with an ISO 8601 timestamp.

```bash
curl -X POST http://localhost:8080/commutes/ingest \
  -H "Content-Type: application/json" \
  -d '{"user_id": "1234", "latitude": 46.105811, "longitude": 14.545298, "timestamp": "2026-05-16T08:00:00Z"}'
```

Ingest a few more points with the same user to build a commute path.

### Check intersections between two users

```bash
curl -X POST http://localhost:8080/commutes/intersections \
  -H "Content-Type: application/json" \
  -d '{"user_id_a": "1234", "user_id_b": "5678"}'
```

Returns `{"shared_cells": [...]}` with the H3 cells both users share, or `{"shared_cells": []}` if they never crossed paths.

### Simulation tool in browser for recording locations

Navigate to [http://localhost:8080/?user_id=1234](http://localhost:8080/?user_id=1234)
Change user_id for simulating multiple users.

## Database

The app connects to `postgresql://postgres:postgres@localhost:5432/postgres-h3-db`.
The database must have the H3 extension installed (provided by `pg_h3`).

Connection URL and H3 resolution are configurable constants at the top of `app.py`.

## Running tests

```bash
./test_scripts/run_unittests_python.sh commute-backend
```
