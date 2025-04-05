#!/bin/bash
if [ -z "$1" ] ; then
  echo "usage: $0 port"
  exit 1
fi

PORT="$1"
shift

PGPASSWORD=exp psql -Uexp -h 127.0.0.1 -p "$PORT" "$@"
