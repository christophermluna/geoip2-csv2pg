#!/bin/bash

set -eux

# create tables
psql -d mm_database -U root -a -v "ON_ERROR_STOP=1" --file=/share/sql/schema.sql

SHARE=/share/dbs
pushd $SHARE || exit 1
# PRODUCTS=("GeoIP2-Anonymous-IP" "GeoIP2-Enterprise" "GeoLite2-City")
PRODUCTS=("GeoIP2-Enterprise")

for PRODUCT in "${PRODUCTS[@]}"; do
    echo "🎸 starting product $PRODUCT"
    FILE_PREFIX="${SHARE}/${PRODUCT}/${PRODUCT}"
    NETWORK_SQL="/share/sql/copy_network-${PRODUCT}.sql"

    psql -d mm_database -U root -a -v "ON_ERROR_STOP=1" -v file="${FILE_PREFIX}-Blocks-IPv4.csv" -f "$NETWORK_SQL"
    psql -d mm_database -U root -a -v "ON_ERROR_STOP=1" -v file="${FILE_PREFIX}-Blocks-IPv6.csv" -f "$NETWORK_SQL"

    LOCATIONS_FILE="${FILE_PREFIX}-Locations-en.csv"
    if [[ -f $LOCATIONS_FILE ]]; then
        psql -d mm_database -U root -a -v "ON_ERROR_STOP=1" -v file="$LOCATIONS_FILE" -f /share/sql/copy_location.sql
    fi

done
