#!/bin/bash
set -e

# Remove a pre-existing server.pid for Rails
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# Wait for the database to be ready
until pg_isready -h "$POSTGRES_HOST" -U "$POSTGRES_USER"; do
  echo "Waiting for database..."
  sleep 2
done

exec "$@"
