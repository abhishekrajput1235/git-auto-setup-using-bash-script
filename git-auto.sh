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

# Check if there are uncommitted or untracked changes
if [[ -z $(git status --porcelain) ]]; then
  echo "⚠️ No changes to commit or push. Exiting..."
  exit 0
fi

# Ask to change remote origin
if git remote | grep -q origin; then
  read -p "❓ Do you want to change the remote 'origin'? (yes/no): " change_remote
  if [[ "$change_remote" == "yes" || "$change_remote" == "y" ]]; then
    git remote remove origin
    read -p "🔗 Enter new remote Git URL: " remote_url
    git remote add origin "$remote_url"
    echo "✅ Remote 'origin' changed."
  else
    echo "⏩ Keeping existing remote origin."
  fi
else
  read -p "🔗 No remote 'origin' found. Enter remote Git URL to add: " remote_url
  git remote add origin "$remote_url"
  echo "✅ Remote 'origin' added."
fi

# Stash uncommitted changes
echo "🧳 Stashing uncommitted changes..."
git stash push -m "Auto stash before pull & commit"
stash_applied=true

# Create/switch to the desired branch
if git rev-parse --verify "$branch_name" >/dev/null 2>&1; then
  echo "🔀 Switching to branch '$branch_name'"
  git checkout "$branch_name"
else
  echo "🌿 Creating and switching to branch '$branch_name'"
  git checkout -b "$branch_name"
fi

# Ask if user wants to pull before commit
read -p "🔄 Do you want to pull the latest changes from origin/$branch_name before committing? (yes/no): " do_pull
if [[ "$do_pull" == "yes" || "$do_pull" == "y" ]]; then
  echo "⬇️ Pulling latest changes from origin/$branch_name..."
  git pull origin "$branch_name" --rebase --allow-unrelated-histories
else
  echo "⏩ Skipping pull as requested."
fi

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
  echo "⚠️ No changes staged for commit. Exiting..."
  exit 0
else
  echo "✅ Committing with message: '$commit_message'"
  git commit -m "$commit_message"
fi

# Push to remote branch
echo "🚀 Pushing to origin/$branch_name"
git push -u origin "$branch_name"

echo "🎉🎉🎉 Your project pushed successfully on GitHub! 🎉🎉🎉"
