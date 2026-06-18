#!/usr/bin/env bash
# Met à jour le PDF en ligne en une commande.
#
# Usage :
#   ./update.sh                       -> prend le PDF le plus récent dans ~/Downloads
#   ./update.sh ~/Downloads/mon.pdf   -> prend le PDF que tu indiques
#
# Dans tous les cas, le fichier est renommé en document.pdf (nom FIXE,
# pour que le QR code déjà imprimé continue de marcher), puis poussé sur GitHub.

set -euo pipefail
cd "$(dirname "$0")"

if [ $# -ge 1 ]; then
  SRC="$1"
else
  # PDF le plus récemment modifié dans ~/Downloads
  SRC="$(ls -t "$HOME/Downloads/"*.pdf 2>/dev/null | head -n 1 || true)"
fi

if [ -z "${SRC:-}" ] || [ ! -f "$SRC" ]; then
  echo "❌ PDF introuvable. Donne le chemin : ./update.sh ~/Downloads/ton-fichier.pdf"
  exit 1
fi

echo "📄 Source : $SRC"
cp "$SRC" document.pdf

git add document.pdf
if git diff --cached --quiet; then
  echo "ℹ️  Le PDF est identique à celui en ligne, rien à mettre à jour."
  exit 0
fi

git commit -m "update: nouveau PDF ($(basename "$SRC"))"
git push

echo "✅ PDF mis à jour. Le lien et le QR code pointent maintenant vers la nouvelle version."
echo "   (Compte ~1 à 2 min + vide le cache du navigateur si tu vois encore l'ancien.)"
