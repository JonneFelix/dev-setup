#!/bin/bash
# ═══════════════════════════════════════════════════════
# Help / Cheatsheet (h)
# ═══════════════════════════════════════════════════════
h() {
  echo "
╔════════════════════════════════════════════════════════════════╗
║                     SHORTCUTS CHEATSHEET                        ║
╠════════════════════════════════════════════════════════════════╣
║  NAVIGATION                                                     ║
║    dev       → ~/Programmieren     proj     → ~/Jonne_Felix    ║
║    ..        → cd ..               ...      → cd ../..         ║
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
║    fcd       → Fuzzy cd (Ordner suchen & wechseln)             ║
║    fopen     → Datei suchen & in VS Code öffnen                ║
║    fkill     → Prozess suchen & beenden                        ║
╠════════════════════════════════════════════════════════════════╣
║  UTILITIES                                                      ║
║    clean     → rm node_modules     ports    → show open ports  ║
║    ip        → lokale IP           myip     → externe IP       ║
║    c         → clear               bat      → cat mit Farben   ║
╚════════════════════════════════════════════════════════════════╝
"
}
