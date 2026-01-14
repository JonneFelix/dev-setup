#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
#  DEV-SETUP INSTALLER
#  One-liner: curl -fsSL https://raw.githubusercontent.com/JonneFelix/dev-setup/main/install.sh | bash
# ═══════════════════════════════════════════════════════════════════

set -e

REPO="https://github.com/JonneFelix/dev-setup"
DOTFILES_DIR="$HOME/.dotfiles"

echo "
╔═══════════════════════════════════════════════════════════════════╗
║                    DOTFILES INSTALLER                             ║
╚═══════════════════════════════════════════════════════════════════╝
"

# ───────────────────────────────────────────────────────────────────
# 1. HOMEBREW
# ───────────────────────────────────────────────────────────────────
if ! command -v brew &> /dev/null; then
    echo "📦 Installiere Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ───────────────────────────────────────────────────────────────────
# 2. CLONE DOTFILES
# ───────────────────────────────────────────────────────────────────
echo "📥 Clone dotfiles..."
if [ -d "$DOTFILES_DIR" ]; then
    cd "$DOTFILES_DIR" && git pull
else
    git clone "$REPO" "$DOTFILES_DIR"
fi
cd "$DOTFILES_DIR"

# ───────────────────────────────────────────────────────────────────
# 3. HOMEBREW PAKETE
# ───────────────────────────────────────────────────────────────────
echo "📦 Installiere Tools..."
brew install starship fzf fd bat 2>/dev/null || true

# ───────────────────────────────────────────────────────────────────
# 4. SYMLINKS
# ───────────────────────────────────────────────────────────────────
echo "🔗 Erstelle Symlinks..."

# Config-Dateien
mkdir -p ~/.config/shell
ln -sf "$DOTFILES_DIR/config/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES_DIR/config/gitignore_global" ~/.gitignore_global
ln -sf "$DOTFILES_DIR/config/editorconfig" ~/.editorconfig
ln -sf "$DOTFILES_DIR/shell/functions.sh" ~/.config/shell/functions.sh

# AI Rules
mkdir -p ~/.claude ~/.cursor/rules
ln -sf "$DOTFILES_DIR/ai-rules/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$DOTFILES_DIR/ai-rules/cursor-global.mdc" ~/.cursor/rules/global.mdc

# ───────────────────────────────────────────────────────────────────
# 5. GIT CONFIG
# ───────────────────────────────────────────────────────────────────
echo "🔧 Konfiguriere Git..."
git config --global core.excludesfile ~/.gitignore_global

# Einfache Aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg "log --oneline --graph --decorate -15"
git config --global alias.undo 'reset --soft HEAD~1'
git config --global alias.amend 'commit --amend --no-edit'

# Komplexe Aliases
git config --global alias.sync '!git fetch --prune && git pull --rebase && git push'
git config --global alias.fresh '!git checkout main && git pull && git branch --merged | grep -v main | xargs -r git branch -d'
git config --global alias.wip '!git add -A && git commit -m "WIP"'
git config --global alias.done '!git add -A && git commit -m "done" && git push'
git config --global alias.nuke '!git reset --hard && git clean -fd'

# ───────────────────────────────────────────────────────────────────
# 6. SHELL CONFIG
# ───────────────────────────────────────────────────────────────────
echo "🐚 Konfiguriere Shell..."

if grep -q "# === DOTFILES ===" ~/.zshrc 2>/dev/null; then
    echo "   Shell bereits konfiguriert"
else
    cat >> ~/.zshrc << 'ZSHRC'

# === DOTFILES === (Managed by dotfiles repo)

# Starship
eval "$(starship init zsh)"

# fzf
source <(fzf --zsh)

# Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'

# Dev
alias uvr='uv run'
alias br='bun run'
alias bd='bun dev'
alias bt='bun test'

# Git
alias gs='git status'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'

# Docker
alias d='docker'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}"'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcl='docker compose logs -f'
alias dcp='docker compose pull'
alias dex='docker exec -it'
alias dprune='docker system prune -af'

# Utils
alias ports='lsof -i -P | grep LISTEN'
alias ip='ipconfig getifaddr en0'
alias myip='curl -s ifconfig.me'
alias clean='find . -name "node_modules" -type d -prune -exec rm -rf {} + 2>/dev/null; find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null; echo "Cleaned!"'

# Claude Code
alias claude='claude --dangerously-skip-permissions'

# fzf config
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border=rounded --info=inline --prompt='❯ ' --pointer='▶' --marker='✓' --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range=:500 {} 2>/dev/null || cat {}' --preview-window=right:60%:wrap"
export FZF_ALT_C_OPTS="--preview 'ls -la {} | head -20' --preview-window=right:40%"

# fzf functions
fcd() { local dir; dir=$(fd --type d --hidden --follow --exclude .git . "${1:-.}" | fzf --preview 'ls -la {}') && cd "$dir"; }
fopen() { local file; file=$(fzf --preview 'bat --style=numbers --color=always {}') && code "$file"; }
fkill() { local pid; pid=$(ps -ef | sed 1d | fzf --header='Select process to kill' | awk '{print $2}'); [ -n "$pid" ] && kill -9 "$pid"; }

# h function
[ -f ~/.config/shell/functions.sh ] && source ~/.config/shell/functions.sh

# === END DOTFILES ===
ZSHRC
fi

# ───────────────────────────────────────────────────────────────────
# DONE
# ───────────────────────────────────────────────────────────────────
echo "
╔═══════════════════════════════════════════════════════════════════╗
║  ✅ INSTALLATION COMPLETE                                         ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  1. Öffne ein NEUES Terminal                                      ║
║  2. Tippe 'h' für alle Shortcuts                                  ║
║                                                                   ║
║  Optional:                                                        ║
║    code --install-extension charliermarsh.ruff                    ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"
