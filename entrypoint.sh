#!/bin/sh
if [ "$RUN_MIGRATIONS" = "True" ]; then
echo "Applying database migrations..."
  echo "Running migrations..."
  python manage.py migrate
fi

exec "$@"