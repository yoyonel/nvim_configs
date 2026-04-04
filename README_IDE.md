# 🛡️ Guide de Survie : Neovim IDE (Bazzite/Distrobox Edition)

Ce document récapitule tous les réglages et "hacks" mis en place pour transformer Neovim en un environnement stable et performant, équivalent à VSCode, malgré les complexités du système Fedora Silverblue / Bazzite.

## 🧱 1. Stabilité Système (Neovim 0.12.0+)
Le passage à Neovim 0.12 a introduit des dépréciations bruyantes et des changements d'APIs.
- **Silence des Warnings** : Ajout d'une neutralisation de `vim.deprecate` et `vim.notify` dans `init.lua`.
- **Patch Telescope** : Ajout d'un polyfill `ft_to_lang` pour éviter les crashs sur Neovim 0.12+ (fonction `ft_to_lang` manquante dans `vim.treesitter`).
- **Sauvegarde Automatique** : `inc-rename.nvim` est maintenant couplé à un `post_hook` qui fait un `silent! wa` dès que tu valides un renommage. Cela force Clangd à rafraîchir son index instantanément.

## 🏹 2. Correction des Touches Directionnelles (Flèches 'A', 'B'...)
Si Neovim est occupé, les séquences ANSI des flèches peuvent être brisées (le `ESC` est séparé de la lettre).
- **Fix** : `vim.opt.ttimeoutlen = 50`.
- **Effet** : Les flèches sont maintenant interprétées en un seul bloc de 50ms, supprimant l'insertion accidentelle de 'A' ou 'B' en mode Insert.

## 📂 3. Navigation & Dashboard (Alpha + Telescope)
Nous avons corrigé l'erreur "Command not found" du Dashboard !
- **Lazy Loading** : Les plugins `Telescope` et `Neo-tree` ont maintenant l'argument `cmd` dans leur définition `lazy.nvim`.
- **Résultat** : CLIQUER sur un bouton du Dashboard (ex : "Fichiers récents") réveille maintenant Telescope automatiquement.

## 🦀 4. Le Cas Particularier de C/C++ (Clangd & Distrobox)
C'est le point de friction majeur : le décalage de racines entre ton container et ton hôte.
- **Mapping de Chemins** : Argument `--path-mappings=/home/latty=/var/home/latty`. 
- **Pourquoi ?** Parce que ton JSON de compilation est généré dans un container (`/home/latty`), mais ton Neovim tourne en réel (`/var/home/latty`). Clangd a besoin de ce "pont" pour trouver tes tests et tes headers.
- **Indexation** : Activation de `--background-index` et `--compile-commands-dir=build`.

## 🛠️ Commandes de secours (Bouton MAJ & Réparer)
Si l'IDE semble cassé (icônes manquantes, pas de couleurs) :
1. Sur le Dashboard, appuie sur **MAJ & Réparer (u)**.
2. Cela lance à la suite : `Lazy sync`, `TSUpdate` et `MasonUpdate`.

---
*Configuration fixée le 04 Avril 2026. Stabilité actuelle : Haute.*
