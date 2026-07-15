#!/usr/bin/env sh
set -e

# Run migrations on startup. Idempotent: if there are no pending migrations,
# alembic returns successfully. The seed step likewise creates only what's missing.
echo "Running database migrations..."
alembic upgrade head

echo "Seeding default data (admin user, demo customers)..."
python -m app.scripts.seed || echo "seed: non-fatal failure, continuing"

# Railway (and other PaaS) inject $PORT; fall back to 8000 for local/compose.
PORT="${PORT:-8000}"
echo "Starting API on 0.0.0.0:${PORT}"
exec uvicorn app.main:app --host 0.0.0.0 --port "${PORT}" --proxy-headers
