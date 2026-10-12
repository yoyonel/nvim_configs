#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Script de capture d'écran X11 pour Neovim (Dashboard / UI)
# Utilise un émulateur de terminal disponible (alacritty, kitty, mate-terminal, xterm)
# et capture la fenêtre via xwd + ffmpeg.
# ==============================================================================

OUTPUT="${1:-screenshots/dashboard.png}"
DELAY="${2:-2.5}"
TITLE="nvim_capture_$(date +%s)_$RANDOM"

mkdir -p "$(dirname "$OUTPUT")"

# Vérification des outils nécessaires
if ! command -v xdotool >/dev/null 2>&1; then
    echo "❌ Erreur: xdotool est requis pour la capture X11." >&2
    exit 1
fi

if ! command -v xwd >/dev/null 2>&1; then
    echo "❌ Erreur: xwd est requis pour la capture X11." >&2
    exit 1
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "❌ Erreur: ffmpeg est requis pour convertir la capture xwd en png." >&2
    exit 1
fi

# Détection du terminal disponible
TERM_BIN=""
if command -v alacritty >/dev/null 2>&1; then
    TERM_BIN="alacritty"
    TERM_CMD=("alacritty" "--title" "$TITLE" "-e" "nvim")
elif command -v kitty >/dev/null 2>&1; then
    TERM_BIN="kitty"
    TERM_CMD=("kitty" "--title" "$TITLE" "nvim")
elif command -v mate-terminal >/dev/null 2>&1; then
    TERM_BIN="mate-terminal"
    TERM_CMD=("mate-terminal" "--title=$TITLE" "-e" "nvim")
elif command -v xterm >/dev/null 2>&1; then
    TERM_BIN="xterm"
    TERM_CMD=("xterm" "-title" "$TITLE" "-e" "nvim")
else
    echo "❌ Erreur: Aucun terminal compatible trouvé (alacritty, kitty, mate-terminal, xterm)." >&2
    exit 1
fi

echo "🚀 Lancement de Neovim dans $TERM_BIN (titre: $TITLE)..."
"${TERM_CMD[@]}" &
TERM_PID=$!

cleanup() {
    if [ -n "${WID:-}" ]; then
        xdotool windowclose "$WID" 2>/dev/null || true
    fi
    kill "$TERM_PID" 2>/dev/null || true
    rm -f "/tmp/${TITLE}.xwd"
}
trap cleanup EXIT

echo "⏳ Attente du rendu UI ($DELAY s)..."
sleep "$DELAY"

WID=""
for _ in {1..10}; do
    WID=$(xdotool search --name "$TITLE" 2>/dev/null | tail -n 1 || true)
    if [ -n "$WID" ]; then
        break
    fi
    sleep 0.5
done

if [ -z "$WID" ]; then
    echo "❌ Impossible de trouver la fenêtre X11 avec le titre '$TITLE'." >&2
    exit 1
fi

echo "📸 Capture de la fenêtre X11 (WID: $WID)..."
xwd -id "$WID" -silent -out "/tmp/${TITLE}.xwd"

echo "🎨 Conversion en PNG -> $OUTPUT..."
ffmpeg -y -i "/tmp/${TITLE}.xwd" "$OUTPUT" >/dev/null 2>&1

if [ -f "$OUTPUT" ]; then
    SIZE=$(ls -lh "$OUTPUT" | awk '{print $5}')
    echo "✅ Capture réussie : $OUTPUT ($SIZE)"
else
    echo "❌ Échec de la génération du fichier PNG !" >&2
    exit 1
fi
