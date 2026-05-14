#!/bin/sh
# Runs in minio-init (docker-compose). Creates bucket + ILM so ARCHITECTURE.md matches reality.
set -e
mc alias set local "http://minio:9000" "$MINIO_USER" "$MINIO_PASS"
mc mb "local/${MINIO_BUCKET}" --ignore-existing

# Idempotent: clear existing lifecycle rules, then apply a single 90d expiry on raw events.
set +e
mc ilm rule rm --all --force "local/${MINIO_BUCKET}" 2>/dev/null
set -e

mc ilm rule add --prefix "events/" "local/${MINIO_BUCKET}" --expire-days 90

echo "MinIO ready: bucket ${MINIO_BUCKET}, ILM expire 90d on prefix events/."
