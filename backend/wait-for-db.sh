#!/bin/sh
set -e

DB_HOST=$(echo "$DATABASE_URL" | sed -E 's|^.*@([^:/]+).*|\1|')
[ -z "$DB_HOST" ] && DB_HOST="db"

DB_PORT=5432

echo "Aguardando Postgres em $DB_HOST:$DB_PORT..."

python3 - <<PYCODE
import socket, time, sys

host = "${DB_HOST}"
port = ${DB_PORT}
attempts = 120

for _ in range(attempts):
    try:
        with socket.create_connection((host, port), timeout=1):
            print("Postgres acessível. Seguindo...")
            sys.exit(0)
    except OSError:
        time.sleep(1)

print("Falha ao conectar ao Postgres dentro do tempo limite.", file=sys.stderr)
sys.exit(1)
PYCODE
