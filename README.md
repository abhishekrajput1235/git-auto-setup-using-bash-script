# 🚀 Git Auto Setup Using Bash Script

This Bash script automates the entire Git workflow, including repository initialization, branch switching, commit creation, remote setup, and push — all through an interactive CLI.

---

## ✅ Features

- Interactive prompts for branch name and commit message
- Initializes Git repo if not already
- Shows current Git status
- Stashes uncommitted changes (if any)
- Creates or switches to the target branch
- Configures `origin` remote if missing
- Pulls latest changes with `--allow-unrelated-histories`
- Restores stashed changes after pulling
- Adds and commits only if changes exist
- Pushes to the appropriate branch

---

## 🛠️ Requirements

- Git installed
- Bash shell (Linux, macOS, WSL, or Git Bash for Windows)

---

## 📦 How to Use

1. Clone or download the script:
   ```bash
   git clone https://github.com/yourusername/git-auto-setup-using-bash-script.git
   cd git-auto-setup-using-bash-script
2. Make the script executable:
   ```bash
        chmod +x git-auto.sh
3. Run the script:
   ```bash
        ./git-auto.sh
