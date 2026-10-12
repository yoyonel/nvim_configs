#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Script de déploiement et synchronisation de la config Neovim vers ~/.config/nvim
# Actions disponibles :
#   sync    : Synchronise les fichiers du repo vers ~/.config/nvim (rsync)
#   link    : Crée un lien symbolique ~/.config/nvim pointant vers ce repo
#   diff    : Affiche les différences entre ce repo et ~/.config/nvim
#   status  : Affiche l'état de synchronisation
# ==============================================================================

ACTION="${1:-status}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${HOME}/.config/nvim"

case "$ACTION" in
    sync)
        echo "📦 Synchronisation du repo vers $TARGET_DIR..."
        mkdir -p "$TARGET_DIR"
        rsync -av --delete \
            --exclude=".git" \
            --exclude=".github" \
            --exclude="screenshots" \
            --exclude=".pre-commit-config.yaml" \
            "$REPO_DIR/" "$TARGET_DIR/"
        echo "✅ Synchronisation terminée avec succès !"
        ;;

    link)
        echo "🔗 Création du lien symbolique vers $REPO_DIR..."
        if [ -L "$TARGET_DIR" ]; then
            CURRENT_LINK="$(readlink -f "$TARGET_DIR")"
            if [ "$CURRENT_LINK" = "$REPO_DIR" ]; then
                echo "ℹ️  $TARGET_DIR pointe déjà sur $REPO_DIR."
                exit 0
            fi
            rm "$TARGET_DIR"
        elif [ -d "$TARGET_DIR" ]; then
            BACKUP="${TARGET_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
            echo "⚠️  Dossier existant détecté, sauvegarde dans $BACKUP..."
            mv "$TARGET_DIR" "$BACKUP"
        fi
        ln -s "$REPO_DIR" "$TARGET_DIR"
        echo "✅ Lien symbolique créé : $TARGET_DIR -> $REPO_DIR"
        ;;

    diff)
        echo "🔍 Différences entre repo local ($REPO_DIR) et hôte ($TARGET_DIR) :"
        if [ ! -d "$TARGET_DIR" ]; then
            echo "❌ $TARGET_DIR n'existe pas !"
            exit 1
        fi
        diff -u -r \
            --exclude=".git" \
            --exclude=".github" \
            --exclude="screenshots" \
            --exclude="lazy-lock.json" \
            "$REPO_DIR" "$TARGET_DIR" || true
        ;;

    status)
        echo "📊 État de la configuration hôte :"
        if [ -L "$TARGET_DIR" ]; then
            echo "🔗 Mode: Lien symbolique ($TARGET_DIR -> $(readlink -f "$TARGET_DIR"))"
        elif [ -d "$TARGET_DIR" ]; then
            echo "📁 Mode: Dossier physique séparé"
            DIFF_COUNT=$( (diff -rq --exclude=".git" --exclude=".github" --exclude="screenshots" --exclude="lazy-lock.json" "$REPO_DIR" "$TARGET_DIR" 2>/dev/null || true) | wc -l | tr -d '[:space:]')
            if [ "$DIFF_COUNT" = "0" ]; then
                echo "✅ Synchronisé (0 fichier différent)"
            else
                echo "⚠️  Désynchronisé ($DIFF_COUNT fichier(s) différent(s)) - Lancer 'task host:diff' ou 'task host:sync'"
            fi
        else
            echo "❌ Non installé ($TARGET_DIR introuvable)"
        fi
        ;;

    *)
        echo "Usage: $0 {sync|link|diff|status}" >&2
        exit 1
        ;;
esac
