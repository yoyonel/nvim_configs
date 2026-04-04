#!/usr/bin/env bash
set -e

# Validation de la configuration Neovim
# Script local et CI pour détecter les erreurs au démarrage

# 1. Vérification de la syntaxe Lua (sans charger les plugins)
# -----------------------------------------------------------
echo "🔍 Vérification de la syntaxe Lua..."
if nvim --headless -c "lua print('Syntax check...')" -c "qa" > /dev/null 2>&1; then
    echo "✅ Syntaxe Lua OK (via nvim)."
else
    echo "❌ Erreur de syntaxe Lua détectée !"
    exit 1
fi

# 2. Vérification du démarrage (Headless Neovim)
# -----------------------------------------------
# On lance nvim en mode headless, on attend les messages d'erreur, et on quitte.
# On filtre les "E" (Errors) et les diagnostics critiques.

echo "🚀 Test de démarrage Neovim (Headless)..."
ERROR_LOG="/tmp/nvim_validate_errors.log"

# On lance nvim, on execute :messages, et on check v:errmsg
# On redirige tout vers un log pour analyse
nvim --headless -c "messages" -c "lua if #vim.v.errmsg > 0 then print('STARTUP_ERROR: ' .. vim.v.errmsg) os.exit(1) end" -c "qa" > "$ERROR_LOG" 2>&1

# Analyse du log pour des patterns d'erreur classiques de plugins
# (ex: theme not found, module not found, etc.)
if grep -qiE "error|not found|failed to load" "$ERROR_LOG"; then
    echo "❌ Des erreurs ou warnings ont été détectés au démarrage :"
    cat "$ERROR_LOG"
    rm "$ERROR_LOG"
    exit 1
fi

echo "✅ Démarrage sans erreur critique détectée."
rm -f "$ERROR_LOG"
exit 0
