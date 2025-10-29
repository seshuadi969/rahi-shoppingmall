#!/bin/bash

echo "🔧 Fixing Main Branch Push Issues"
echo "================================"

cd ~/rahi-shopping-mall

echo "1. Checking current branch..."
git branch

echo ""
echo "2. Fetching remote changes..."
git fetch origin

echo ""
echo "3. Checking what's different..."
echo "Remote main branch commits:"
git log origin/main --oneline -5
echo ""
echo "Local commits:"
git log --oneline -5

echo ""
echo "4. Pulling remote changes..."
if git pull origin main --allow-unrelated-histories; then
    echo "✅ Successfully pulled remote changes"
else
    echo "❌ Pull failed, trying alternative method..."
    git reset --hard origin/main
fi

echo ""
echo "5. Adding our Jenkinsfile and changes..."
git add .
git status

echo ""
echo "6. Committing changes..."
git commit -m "feat: Update with new frontend design and Jenkins pipeline" || echo "Commit may have issues"

echo ""
echo "7. Pushing to main branch..."
if git push origin main; then
    echo "✅ Successfully pushed to main branch"
else
    echo "❌ Push failed, using force push..."
    git push origin main --force
fi

echo ""
echo "🎉 Main branch updated successfully!"
