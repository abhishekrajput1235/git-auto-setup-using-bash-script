#!/bin/bash

echo "🔧 Git Automation Script"

# Prompt for branch name and commit message
read -p "👉 Enter the branch name: " branch_name
read -p "📝 Enter the commit message: " commit_message

# Initialize Git if not already
if [ ! -d ".git" ]; then
  echo "📦 Initializing Git repository..."
  git init
fi

# Show current status
echo "📋 Current Git status:"
git status

# Stash uncommitted changes (if any)
if [[ -n $(git status --porcelain) ]]; then
  echo "🧳 Stashing uncommitted changes..."
  git stash push -m "Auto stash before pull & commit"
  stash_applied=true
else
  stash_applied=false
fi

# Ensure branch exists
if ! git show-ref --verify --quiet refs/heads/$branch_name; then
  echo "🌿 Creating branch '$branch_name'"
  git checkout -b $branch_name
else
  echo "🔀 Switching to branch '$branch_name'"
  git checkout $branch_name
fi

# Check for remote
if ! git remote | grep -q origin; then
  echo "❌ No remote 'origin' found."
  read -p "🔗 Enter remote Git URL: " remote_url
  git remote add origin "$remote_url"
  echo "✅ Remote 'origin' added."
fi

# Pull latest changes before committing
echo "⬇️ Pulling latest changes from origin/$branch_name..."
git pull origin $branch_name --rebase

# Restore stash if applied earlier
if [ "$stash_applied" = true ]; then
  echo "♻️ Restoring stashed changes..."
  git stash pop
fi

# Add and commit
echo "➕ Adding all changes..."
git add .

echo "✅ Committing with message: '$commit_message'"
git commit -m "$commit_message"

# Push
echo "🚀 Pushing to origin/$branch_name"
git push -u origin $branch_name

echo "🎉 Done!"
