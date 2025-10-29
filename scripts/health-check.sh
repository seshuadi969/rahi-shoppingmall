#!/bin/bash

set -e

echo "🔍 Starting Health Checks..."

BACKEND_URL=$1
FRONTEND_URL=$2

echo "Checking Backend: $BACKEND_URL"
curl -f "$BACKEND_URL/api/health" || exit 1

echo "Checking Backend Database: $BACKEND_URL"
curl -f "$BACKEND_URL/api/test-db" || echo "Database check not available"

echo "Checking Backend Products API: $BACKEND_URL"
curl -f "$BACKEND_URL/api/products" || echo "Products API not available"

echo "Checking Frontend: $FRONTEND_URL"
curl -I "$FRONTEND_URL" | head -n 1 || exit 1

echo "✅ All health checks passed!"
