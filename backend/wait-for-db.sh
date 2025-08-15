#!/bin/sh
set -e

HOST="${DB_HOST:-db}"
PORT="${DB_PORT:-5432}"

echo "Aguardando Postgres em $HOST:$PORT..."

python3 - <<'PYCODE'
import os, socket, time, sys
host = os.getenv("DB_HOST", "db")
port = int(os.getenv("DB_PORT", "5432"))
attempts = 120
for i in range(attempts):
    try:
        with socket.create_connection((host, port), timeout=1):
            print("Postgres acessível. Seguindo...")
            sys.exit(0)
    except OSError:
        time.sleep(1)
print("Falha ao conectar ao Postgres dentro do tempo limite.", file=sys.stderr)
sys.exit(1)
PYCODE
