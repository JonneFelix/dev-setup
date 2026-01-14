# Dotfiles

Meine macOS Entwicklungsumgebung. Ein Befehl - alles eingerichtet.

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/JonneFelix/dotfiles/main/install.sh | bash
```

Danach neues Terminal öffnen und `h` tippen für alle Shortcuts.

## Was wird installiert

### Tools (via Homebrew)
- **starship** - Schöner Terminal-Prompt
- **fzf** - Fuzzy-Finder
- **fd** - Schnelle Dateisuche
- **bat** - cat mit Syntax-Highlighting

### Konfigurationen
- Globale `.gitignore`
- Git Aliases
- Shell Aliases
- AI Rules (Claude Code + Cursor)
- EditorConfig

## Shortcuts

Tippe `h` im Terminal für die komplette Liste.

### Git
| Shortcut | Befehl |
|----------|--------|
| `gs` | git status |
| `gp` | git push |
| `gl` | git pull |
| `git lg` | Log mit Graph |
| `git sync` | fetch + pull + push |
| `git wip` | Quick WIP commit |

### Docker
| Shortcut | Befehl |
|----------|--------|
| `dps` | Container Liste |
| `dcu` | compose up -d |
| `dcd` | compose down |
| `dcl` | compose logs |

### fzf
| Shortcut | Beschreibung |
|----------|--------------|
| `Ctrl+T` | Dateien suchen |
| `Ctrl+R` | History |
| `fcd` | Fuzzy cd |
| `fopen` | Datei in VS Code öffnen |

## Stack

- Python: `uv`
- TypeScript: `bun`
- Formatting: Ruff (Python), Prettier (TS)
