#!/bin/bash

set -e

echo "🚀 Starting Frontend Deployment..."

ENVIRONMENT=$1
BUILD_NUMBER=$2

cd frontend

echo "📦 Installing dependencies..."
npm ci

echo "🏗️ Building application..."
npm run build

echo "🔍 Verifying build..."
if [ ! -d "dist" ] || [ ! -f "dist/index.html" ]; then
    echo "❌ Build failed - dist directory not found"
    exit 1
fi

echo "🚀 Deploying to $ENVIRONMENT..."
npm install -g vercel

if [ "$ENVIRONMENT" == "production" ]; then
    vercel --prod --token $VERCEL_TOKEN --confirm
    DEPLOY_URL="https://rahi-shopping-mall.vercel.app"
else
    vercel --token $VERCEL_TOKEN --confirm
    DEPLOY_URL="https://staging.rahi-shopping-mall.vercel.app"
fi

echo "✅ Frontend deployed successfully to $DEPLOY_URL"i
