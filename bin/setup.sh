#!/bin/bash

DBMS=postgres
PORT=15432

cat sql/schema-$DBMS.sql | bin/connect-$DBMS.sh "$PORT"
cat sql/data-setup.sql | bin/connect-$DBMS.sh "$PORT"
