#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
#  DEV SETUP SCRIPT
#  Optimierte Entwicklungsumgebung für macOS (zsh)
#  Stack: Python (uv) + TypeScript (bun)
# ═══════════════════════════════════════════════════════════════════

set -e

echo "
╔═══════════════════════════════════════════════════════════════════╗
║               DEV ENVIRONMENT SETUP                               ║
║  Installiert: Starship, fzf, Git Aliases, Shell Aliases, etc.    ║
╚═══════════════════════════════════════════════════════════════════╝
"

# ───────────────────────────────────────────────────────────────────
# 1. HOMEBREW PAKETE
# ───────────────────────────────────────────────────────────────────
echo "📦 Installiere Homebrew Pakete..."
if command -v brew &> /dev/null; then
    brew install starship fzf fd bat 2>/dev/null || true
    echo "✅ Pakete installiert"
else
    echo "⚠️  Homebrew nicht gefunden. Bitte erst installieren: https://brew.sh"
    exit 1
fi

# ───────────────────────────────────────────────────────────────────
# 2. GLOBALE .gitignore
# ───────────────────────────────────────────────────────────────────
echo "📝 Erstelle globale .gitignore..."
cat > ~/.gitignore_global << 'GITIGNORE'
# Dependencies
node_modules/
.pnpm-store/
bun.lockb

# Python
venv/
.venv/
__pycache__/
*.py[cod]
.uv/
.python-version

# Build outputs
dist/
build/
.next/
.nuxt/
.output/
*.egg-info/

# IDE & Editor
.idea/
.vscode/
*.swp
*.swo
.DS_Store

# Environment & Secrets
.env
.env.local
.env*.local
*.pem
*.key

# Logs & Cache
*.log
npm-debug.log*
.cache/
.turbo/

# Testing
coverage/
.nyc_output/
.pytest_cache/
GITIGNORE

git config --global core.excludesfile ~/.gitignore_global
echo "✅ Globale .gitignore erstellt"

# ───────────────────────────────────────────────────────────────────
# 3. GIT ALIASES
# ───────────────────────────────────────────────────────────────────
echo "🔧 Konfiguriere Git Aliases..."

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

echo "✅ Git Aliases konfiguriert"

# ───────────────────────────────────────────────────────────────────
# 4. EDITORCONFIG
# ───────────────────────────────────────────────────────────────────
echo "📐 Erstelle .editorconfig..."
cat > ~/.editorconfig << 'EDITORCONFIG'
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.py]
indent_size = 4

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
EDITORCONFIG
echo "✅ EditorConfig erstellt"

# ───────────────────────────────────────────────────────────────────
# 5. STARSHIP CONFIG
# ───────────────────────────────────────────────────────────────────
echo "🚀 Konfiguriere Starship Prompt..."
mkdir -p ~/.config
cat > ~/.config/starship.toml << 'STARSHIP'
format = """
$directory$git_branch$git_status$python$nodejs$cmd_duration
$character"""

[directory]
truncation_length = 3
style = "bold cyan"

[git_branch]
symbol = " "
style = "bold purple"

[git_status]
style = "bold red"

[python]
symbol = " "
style = "yellow"

[nodejs]
symbol = " "
style = "green"

[cmd_duration]
min_time = 2000
style = "yellow"

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
STARSHIP
echo "✅ Starship konfiguriert"

# ───────────────────────────────────────────────────────────────────
# 6. AI RULES (Claude Code + Cursor)
# ───────────────────────────────────────────────────────────────────
echo "🤖 Erstelle AI Rules..."
mkdir -p ~/.claude ~/.cursor/rules

cat > ~/.claude/CLAUDE.md << 'CLAUDE'
# Global Rules

## Stack
- Python: use `uv` (not pip/poetry). Commands: `uv init`, `uv add`, `uv run`
- TypeScript: use `bun` (not npm/yarn). Commands: `bun init`, `bun add`, `bun run`
- Formatting: Ruff (Python), Prettier (TS/JS)

## Code Style
- Type hints in Python, strict TypeScript

## Workflow
- Read files before editing
- Always test before marking done
CLAUDE

cat > ~/.cursor/rules/global.mdc << 'CURSOR'
---
description: Global rules for all projects
globs: ["**/*"]
---

# Stack
- Python: `uv` (not pip). Use `uv init`, `uv add`, `uv run`
- TypeScript: `bun` (not npm). Use `bun init`, `bun add`, `bun run`

# Style
- Type hints (Python), strict mode (TS)
- Ruff formatting (Python), Prettier (TS/JS)

# Workflow
- Read before edit
- Test before done
CURSOR
echo "✅ AI Rules erstellt"

# ───────────────────────────────────────────────────────────────────
# 7. SHELL KONFIGURATION (.zshrc Erweiterung)
# ───────────────────────────────────────────────────────────────────
echo "🐚 Konfiguriere Shell..."

# Erstelle h-Funktion Datei
mkdir -p ~/.config/shell
cat > ~/.config/shell/functions.sh << 'FUNCTIONS'
h() {
  echo "
╔════════════════════════════════════════════════════════════════╗
║                     SHORTCUTS CHEATSHEET                        ║
╠════════════════════════════════════════════════════════════════╣
║  DEVELOPMENT                                                    ║
║    uvr       → uv run              br       → bun run          ║
║    bd        → bun dev             bt       → bun test         ║
╠════════════════════════════════════════════════════════════════╣
║  GIT (kurz)                                                     ║
║    gs        → status              gp       → push             ║
║    gl        → pull                gd       → diff             ║
╠════════════════════════════════════════════════════════════════╣
║  GIT (aliases)                                                  ║
║    git co    → checkout            git br   → branch           ║
║    git ci    → commit              git st   → status           ║
║    git lg    → log (graph)         git last → letzter commit   ║
║    git undo  → soft reset          git amend→ amend commit     ║
╠════════════════════════════════════════════════════════════════╣
║  GIT (komplex)                                                  ║
║    git sync  → fetch+pull+push     git fresh→ cleanup branches ║
║    git wip   → quick WIP commit    git done → add+commit+push  ║
║    git nuke  → hard reset+clean (⚠️  VORSICHT!)                ║
╠════════════════════════════════════════════════════════════════╣
║  DOCKER                                                         ║
║    dps       → container list      dpsa     → alle container   ║
║    dcu       → compose up -d       dcd      → compose down     ║
║    dcr       → compose restart     dcl      → compose logs     ║
║    dcp       → compose pull        dex      → exec -it         ║
║    dprune    → system prune (⚠️)                               ║
╠════════════════════════════════════════════════════════════════╣
║  FZF (Fuzzy Finder)                                             ║
║    Ctrl+T    → Dateien suchen (mit Vorschau)                   ║
║    Ctrl+R    → History durchsuchen                              ║
║    Alt+C     → Ordner wechseln (mit Vorschau)                  ║
║    fcd       → Fuzzy cd            fopen    → Datei in VS Code ║
║    fkill     → Prozess beenden                                 ║
╠════════════════════════════════════════════════════════════════╣
║  UTILITIES                                                      ║
║    clean     → rm node_modules     ports    → show open ports  ║
║    ip        → lokale IP           myip     → externe IP       ║
║    c         → clear               bat      → cat mit Farben   ║
╚════════════════════════════════════════════════════════════════╝
"
}
FUNCTIONS

# Prüfe ob bereits konfiguriert
if grep -q "# === DEV-SETUP ===" ~/.zshrc 2>/dev/null; then
    echo "⚠️  Shell bereits konfiguriert, überspringe..."
else
    cat >> ~/.zshrc << 'ZSHRC'

# === DEV-SETUP === (Nicht manuell bearbeiten)

# Starship Prompt
eval "$(starship init zsh)"

# fzf
source <(fzf --zsh)

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Development shortcuts
alias uvr='uv run'
alias br='bun run'
alias bd='bun dev'
alias bt='bun test'

# Quick commands
alias ports='lsof -i -P | grep LISTEN'
alias ip='ipconfig getifaddr en0'
alias myip='curl -s ifconfig.me'
alias c='clear'

# Cleanup
alias clean='find . -name "node_modules" -type d -prune -exec rm -rf {} + 2>/dev/null; find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null; echo "Cleaned!"'

# Git shortcuts
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

# fzf Optimierung
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
  --height 60%
  --layout=reverse
  --border=rounded
  --info=inline
  --prompt='❯ '
  --pointer='▶'
  --marker='✓'
  --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range=:500 {} 2>/dev/null || cat {}' --preview-window=right:60%:wrap"
export FZF_ALT_C_OPTS="--preview 'ls -la {} | head -20' --preview-window=right:40%"

# fzf Funktionen
fcd() { local dir; dir=$(fd --type d --hidden --follow --exclude .git . "${1:-.}" | fzf --preview 'ls -la {}') && cd "$dir"; }
fopen() { local file; file=$(fzf --preview 'bat --style=numbers --color=always {}') && code "$file"; }
fkill() { local pid; pid=$(ps -ef | sed 1d | fzf --header='Select process to kill' | awk '{print $2}'); [ -n "$pid" ] && kill -9 "$pid"; }

# h-Funktion laden
[ -f ~/.config/shell/functions.sh ] && source ~/.config/shell/functions.sh

# === END DEV-SETUP ===
ZSHRC
fi

echo "✅ Shell konfiguriert"

# ───────────────────────────────────────────────────────────────────
# 8. VS CODE SETTINGS (optional)
# ───────────────────────────────────────────────────────────────────
VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
if [ -f "$VSCODE_SETTINGS" ]; then
    echo "💻 VS Code gefunden - bitte manuell Python/TS Settings hinzufügen"
    echo "   Ruff Extension: code --install-extension charliermarsh.ruff"
fi

# ───────────────────────────────────────────────────────────────────
# FERTIG
# ───────────────────────────────────────────────────────────────────
echo "
╔═══════════════════════════════════════════════════════════════════╗
║  ✅ SETUP ABGESCHLOSSEN                                           ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  Nächste Schritte:                                                ║
║  1. Öffne ein NEUES Terminal                                      ║
║  2. Tippe 'h' für alle Shortcuts                                  ║
║  3. Installiere VS Code Extension:                                ║
║     code --install-extension charliermarsh.ruff                   ║
║                                                                   ║
║  Getestet? Probiere:                                              ║
║  • Ctrl+R  → History durchsuchen                                  ║
║  • Ctrl+T  → Dateien suchen                                       ║
║  • gs      → git status                                           ║
║  • dps     → docker container                                     ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"
