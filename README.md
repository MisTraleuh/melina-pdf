# melina-pdf

Héberge un PDF sur le web via **GitHub Pages**, avec une **URL fixe** pour que le
QR code imprimé reste valable même quand le PDF est mis à jour.

## Comment ça marche

- Le PDF est stocké sous un **nom fixe** : `document.pdf`
- `index.html` affiche ce PDF dans une page propre
- Le QR code pointe vers l'URL GitHub Pages → tant que le nom du fichier ne change
  pas, le QR reste valable à vie

## URLs (une fois GitHub Pages activé)

- Page d'accueil : `https://mistraleuh.github.io/melina-pdf/`
- PDF direct : `https://mistraleuh.github.io/melina-pdf/document.pdf`

👉 **Génère le QR code à partir de la page d'accueil** (la première URL).

## Mettre à jour le PDF

```bash
./update.sh                      # prend le PDF le plus récent dans ~/Downloads
./update.sh ~/Downloads/mon.pdf  # ou indique le fichier
```

Le script renomme automatiquement en `document.pdf`, commit et push.

## ⚠️ Règle d'or

Ne change **jamais** le nom `document.pdf`, sinon l'URL change et tous les QR codes
déjà imprimés cessent de fonctionner.
