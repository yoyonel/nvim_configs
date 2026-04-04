set unstable := true
set shell := ["bash", "-c"]

export PATH := home_directory() + "/.local/share/nvim/mason/bin:" + env_var("PATH")

# Aide par défaut : Liste les commandes disponibles
default:
    @just --list --unsorted

# --- QUALITÉ DE CODE (Validation / Lint / Format) ---

# Tout valider (Syntaxe + Démarrage)
validate:
    @echo "🧪 Lancement de la validation globale..."
    @bash scripts/validate.sh

# Tout linter (Vérification sans modification)
lint:
    @echo "🕵️‍♀️ Scan de la qualité du code..."
    @stylua --check init.lua lua/ 2>/dev/null || echo "⚠️ stylua a détecté des problèmes !"
    @just --fmt --check 2>/dev/null || echo "⚠️ justification (format) non respecté !"
    @npx -y prettier --check "**/*.{md,json,yaml,yml}" 2>/dev/null || echo "⚠️ Prettier (lint) a détecté des problèmes !"

# Tout formater (Nettoyage automatique)
fmt:
    @echo "✨ Formatage automatique des fichiers..."
    @stylua init.lua lua/
    @just --fmt
    @npx -y prettier --write "**/*.{md,json,yaml,yml}"
    @echo "✅ Tout est propre !"

# --- RACCOURCIS UTILES ---

# Ouvrir nvim sur init.lua
config:
    nvim init.lua

# Recharger les plugins (Lazy sync)
sync:
    nvim --headless "+Lazy! sync" +qa
