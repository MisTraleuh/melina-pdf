#!/usr/bin/env bash
# Met à jour la vidéo en ligne en une commande.
#
# Usage :
#   ./update.sh                       -> prend la vidéo la plus récente dans ~/Downloads
#   ./update.sh ~/Downloads/ma.mp4    -> prend la vidéo que tu indiques
#
# Le fichier est renommé en video.mp4 (nom FIXE, pour que le QR code déjà
# imprimé continue de marcher). GitHub refuse les fichiers > 100 Mo : si la
# vidéo dépasse, le script la ré-encode automatiquement pour passer sous la
# limite, en gardant la meilleure qualité possible. Puis il pousse sur GitHub.

set -euo pipefail
cd "$(dirname "$0")"

# Limite GitHub = 100 Mio. On vise une marge de sécurité à 95 Mo.
LIMIT_BYTES=$((95 * 1000 * 1000))

if [ $# -ge 1 ]; then
  SRC="$1"
else
  SRC="$(ls -t "$HOME/Downloads/"*.mp4 "$HOME/Downloads/"*.mov "$HOME/Downloads/"*.MOV 2>/dev/null | head -n 1 || true)"
fi

if [ -z "${SRC:-}" ] || [ ! -f "$SRC" ]; then
  echo "❌ Vidéo introuvable. Donne le chemin : ./update.sh ~/Downloads/ta-video.mp4"
  exit 1
fi

echo "🎬 Source : $SRC"
SIZE=$(stat -f%z "$SRC")

if [ "$SIZE" -le "$LIMIT_BYTES" ]; then
  echo "✅ Taille OK ($((SIZE/1000/1000)) Mo). Optimisation pour le web (faststart)…"
  ffmpeg -y -i "$SRC" -c copy -movflags +faststart video.mp4
else
  echo "⚠️  $((SIZE/1000/1000)) Mo > 100 Mo : ré-encodage pour passer sous la limite…"
  command -v ffmpeg >/dev/null || { echo "❌ ffmpeg requis : brew install ffmpeg"; exit 1; }
  DUR=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$SRC")
  # bitrate vidéo cible = (90 Mo de budget - audio 128k) réparti sur la durée
  VBIT=$(awk -v d="$DUR" 'BEGIN { printf "%d", (90*8*1000*1000)/d - 128000 }')
  echo "   Durée ${DUR}s -> bitrate vidéo ~$((VBIT/1000)) kbps"
  ffmpeg -y -i "$SRC" -c:v libx264 -preset slow -b:v "$VBIT" -pass 1 -an -f mp4 /dev/null
  ffmpeg -y -i "$SRC" -c:v libx264 -preset slow -b:v "$VBIT" -pass 2 \
         -c:a aac -b:a 128k -movflags +faststart -pix_fmt yuv420p video.mp4
  rm -f ffmpeg2pass-0.log ffmpeg2pass-0.log.mbtree
  echo "   Résultat : $(($(stat -f%z video.mp4)/1000/1000)) Mo"
fi

git add video.mp4
if git diff --cached --quiet; then
  echo "ℹ️  La vidéo est identique à celle en ligne, rien à mettre à jour."
  exit 0
fi

git commit -m "update: nouvelle vidéo ($(basename "$SRC"))"
git push

echo "✅ Vidéo mise à jour. Le lien et le QR code pointent vers la nouvelle version."
echo "   (Compte ~1 à 2 min + vide le cache du navigateur si tu vois encore l'ancienne.)"
