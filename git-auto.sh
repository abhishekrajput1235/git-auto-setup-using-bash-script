#!/bin/bash

echo "🔧 Git Automation Script"

# Prompt for branch name and commit message
read -p "👉 Enter the branch name: " branch_name
read -p "📝 Enter the commit message: " commit_message

# Initialize Git if not already
if [ ! -d ".git" ]; then
  echo "📦 Initializing Git repository..."
  git init
  git config --local init.defaultBranch "$branch_name"
  git checkout -b "$branch_name"
else
  echo "✅ Git repository already initialized."
fi

# Show git status
echo "📋 Git status before changes:"
git status

# Check if there are changes to stash
if [[ -n $(git status --porcelain) ]]; then
  echo "🧳 Stashing uncommitted changes..."
  git stash push -m "Auto stash before pull & commit"
  stash_applied=true
else
  stash_applied=false
fi

# Create/switch to the desired branch
if git rev-parse --verify $branch_name >/dev/null 2>&1; then
  echo "🔀 Switching to branch '$branch_name'"
  git checkout $branch_name
else
  echo "🌿 Creating and switching to branch '$branch_name'"
  git checkout -b $branch_name
fi

# Check for remote origin
if ! git remote | grep -q origin; then
  echo "❌ No remote 'origin' found."
  read -p "🔗 Enter remote Git URL: " remote_url
  git remote add origin "$remote_url"
  echo "✅ Remote 'origin' added."
fi

# Pull latest changes with rebase and allow unrelated histories
echo "⬇️ Pulling latest changes from origin/$branch_name..."
git pull origin $branch_name --rebase --allow-unrelated-histories

# Restore stashed changes
if [ "$stash_applied" = true ]; then
  echo "♻️ Restoring stashed changes..."
  git stash pop || echo "⚠️ Nothing to restore or merge conflict occurred."
fi

# Add and commit changes
echo "➕ Adding changes..."
git add .
git status

# Commit only if there are staged changes
if git diff --cached --quiet; then
  echo "⚠️ No changes to commit."
else
  echo "✅ Committing with message: '$commit_message'"
  git commit -m "$commit_message"
fi

# Push to remote branch
echo "🚀 Pushing to origin/$branch_name"
git push -u origin $branch_name

echo "🎉🎉🎉 Your project push successfully on github! 🎉🎉🎉"
