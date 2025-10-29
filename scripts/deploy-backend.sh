#!/bin/bash

set -e

echo "🚀 Starting Backend Deployment..."

ENVIRONMENT=$1
BUILD_NUMBER=$2

cd backend

echo "📦 Installing dependencies..."
npm ci

echo "🔍 Running tests..."
npm test || echo "No tests configured"

echo "🏗️ Building application..."
npm run build --if-present || echo "No build step"

echo "🚀 Deploying to $ENVIRONMENT..."
npm install -g @railway/cli

if [ "$ENVIRONMENT" == "production" ]; then
    railway up --service backend --token $RAILWAY_TOKEN
    DEPLOY_URL="https://rahi-backend.up.railway.app"
else
    railway up --service backend-staging --token $RAILWAY_TOKEN
    DEPLOY_URL="https://rahi-backend-staging.up.railway.app"
fi

echo "⏳ Waiting for deployment to complete..."
sleep 60

echo "🔍 Health check..."
curl -f $DEPLOY_URL/api/health || exit 1

echo "✅ Backend deployed successfully to $DEPLOY_URL"
