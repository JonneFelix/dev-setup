═══════════════════════════════════════════════════════════════════
                    DEV SETUP - ANLEITUNG
═══════════════════════════════════════════════════════════════════

VORAUSSETZUNGEN:
  • macOS mit zsh (Standard seit Catalina)
  • Homebrew installiert (https://brew.sh)

INSTALLATION:
  1. Öffne Terminal
  2. Führe aus:

     ./dev-setup.sh

     ODER falls nicht im gleichen Ordner:

     bash /pfad/zu/dev-setup.sh

  3. Öffne ein NEUES Terminal-Fenster
  4. Tippe 'h' um alle Shortcuts zu sehen

═══════════════════════════════════════════════════════════════════

WAS WIRD INSTALLIERT:

  Tools:
    • starship    - Schöner Terminal-Prompt
    • fzf         - Fuzzy-Finder (Ctrl+R, Ctrl+T)
    • fd          - Schnellere Dateisuche
    • bat         - cat mit Syntax-Highlighting

  Konfigurationen:
    • Globale .gitignore (node_modules, venv, etc. werden ignoriert)
    • Git Aliases (git co, git lg, git sync, etc.)
    • Shell Aliases (gs, gp, dps, uvr, br, etc.)
    • AI Rules für Claude Code & Cursor
    • EditorConfig für konsistente Formatierung
    • fzf mit Vorschau und Farben

═══════════════════════════════════════════════════════════════════

WICHTIGSTE SHORTCUTS (tippe 'h' für alle):

  Git:          gs (status), gp (push), gl (pull)
  Git Aliases:  git sync, git wip, git done, git lg
  Docker:       dps (list), dcu (up), dcd (down)
  Dev:          uvr (uv run), br (bun run)
  fzf:          Ctrl+R (history), Ctrl+T (files), fcd (cd)

═══════════════════════════════════════════════════════════════════
