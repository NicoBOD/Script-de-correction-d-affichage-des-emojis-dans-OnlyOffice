#!/bin/bash
# Fix emoji display in OnlyOffice (Snap) on Ubuntu 24.04
# Installs Symbola font and clears OnlyOffice font cache

set -e

echo "=== Fix emojis OnlyOffice ==="

# 1. Installer Symbola
if dpkg -l fonts-symbola &>/dev/null; then
    echo "[OK] fonts-symbola déjà installé"
else
    echo "[...] Installation de fonts-symbola..."
    sudo apt-get install -y fonts-symbola
    echo "[OK] fonts-symbola installé"
fi

# 2. Vider le cache de polices OnlyOffice (toutes les révisions snap)
CACHE_BASE="$HOME/snap/onlyoffice-desktopeditors"

if [ ! -d "$CACHE_BASE" ]; then
    echo "[WARN] OnlyOffice (snap) non trouvé dans ~/snap/"
    echo "       Installez OnlyOffice via : sudo snap install onlyoffice-desktopeditors"
    exit 1
fi

CLEARED=0
for REV_DIR in "$CACHE_BASE"/*/; do
    FONTS_DIR="$REV_DIR.local/share/onlyoffice/desktopeditors/data/fonts"
    if [ -d "$FONTS_DIR" ]; then
        echo "[...] Nettoyage du cache : $FONTS_DIR"
        rm -f "$FONTS_DIR"/AllFonts.js* \
              "$FONTS_DIR"/font_selection.bin \
              "$FONTS_DIR"/fonts.log \
              "$FONTS_DIR"/fonts_thumbnail*
        CLEARED=$((CLEARED + 1))
    fi
done

if [ "$CLEARED" -eq 0 ]; then
    echo "[WARN] Aucun cache OnlyOffice trouvé (l'app a-t-elle déjà été lancée ?)"
else
    echo "[OK] Cache vidé ($CLEARED dossier(s) traité(s))"
fi

echo ""
echo "=== Terminé ==="
echo "Relancez OnlyOffice : le premier démarrage sera plus lent (recalcul du cache)."
echo "Les emojis s'afficheront en monochrome (Symbola ne supporte pas la couleur)."
