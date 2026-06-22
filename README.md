# melina-pdf

Héberge une **vidéo** sur le web via **GitHub Pages**, avec une **URL fixe** pour
que le QR code imprimé reste valable même quand la vidéo est mise à jour.

## Comment ça marche

- La vidéo est stockée sous un **nom fixe** : `video.mp4`
- `index.html` la lit en plein écran et la **lance automatiquement** à l'arrivée
  (en sourdine, comme l'exigent les navigateurs ; un bouton « 🔊 Activer le son »
  permet le son en un tap)
- Le QR code pointe vers l'URL GitHub Pages → tant que le nom du fichier ne change
  pas, le QR reste valable à vie

## URLs (GitHub Pages est servi depuis `main` / racine)

- Page d'accueil : `https://mistraleuh.github.io/melina-pdf/`
- Vidéo directe : `https://mistraleuh.github.io/melina-pdf/video.mp4`

👉 **Génère le QR code à partir de la page d'accueil** (la première URL).

## Mettre à jour la vidéo

```bash
./update.sh                       # prend la vidéo la plus récente dans ~/Downloads
./update.sh ~/Downloads/ma.mp4    # ou indique le fichier
```

Le script renomme en `video.mp4`, et **si la vidéo dépasse 100 Mo** (limite stricte
de GitHub) il la **ré-encode automatiquement** pour passer sous la limite tout en
gardant la meilleure qualité possible, puis commit et push.

## ⚠️ Règle d'or

Ne change **jamais** le nom `video.mp4`, sinon l'URL change et tous les QR codes
déjà imprimés cessent de fonctionner.
