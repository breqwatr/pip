#!/bin/bash
if [[ ! -f /devpi/.setup_done ]]; then
  echo "Setting up root user"
  devpi-server --start --host 127.0.0.1 --port $PORT
  devpi-server --status
  devpi use http://localhost:$PORT
  devpi login root --password=''
  devpi user -m root password="${DEVPI_PASSWORD}"
  devpi-server --stop
  touch /devpi/.setup_done
fi

echo "$(date) - Starting devpi-server process"
/usr/local/bin/devpi-server \
  --port $PORT \
  --serverdir /devpi \
  --host $HOST \
  --offline-mode
