#!/bin/bash

BASE="http://localhost:8080"

echo "=== Ingest points for user 1234 ==="
curl -s -X POST "$BASE/commutes/ingest" -H "Content-Type: application/json" \
  -d '{"user_id":"1234","latitude":46.055,"longitude":14.505,"timestamp":"2026-05-16T08:00:00Z"}'
echo
curl -s -X POST "$BASE/commutes/ingest" -H "Content-Type: application/json" \
  -d '{"user_id":"1234","latitude":46.060,"longitude":14.510,"timestamp":"2026-05-16T08:05:00Z"}'
echo

echo "=== Ingest points for user 666 ==="
curl -s -X POST "$BASE/commutes/ingest" -H "Content-Type: application/json" \
  -d '{"user_id":"666","latitude":46.055,"longitude":14.505,"timestamp":"2026-05-16T17:00:00Z"}'
echo
curl -s -X POST "$BASE/commutes/ingest" -H "Content-Type: application/json" \
  -d '{"user_id":"666","latitude":46.062,"longitude":14.508,"timestamp":"2026-05-16T17:05:00Z"}'
echo

echo "=== Check intersection ==="
curl -s -X POST "$BASE/commutes/intersections" -H "Content-Type: application/json" \
  -d '{"user_id_a":"1234","user_id_b":"666"}'
echo
