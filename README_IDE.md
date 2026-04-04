# 🛡️ Guide de Survie : Neovim IDE (Bazzite/Distrobox Edition)

Ce document récapitule tous les réglages et "hacks" mis en place pour transformer Neovim en un environnement stable et performant, équivalent à VSCode, sur Bazzite (Fedora Silverblue).

## 🏆 Version Préférentielle : Neovim v0.10.1 (STABLE)

**IMPORTANT :** Ne pas utiliser les versions Nightly (0.11/0.12) qui cassent les APIs des plugins.

- **Binaire recommandé** : AppImage v0.10.1 située dans `~/.local/bin/nvim`.

## 📂 Nouveaux fichiers de configuration (Boîte à Outils)

Nous avons séparé les outils par responsabilités pour plus de lisibilité :

1.  `lua/plugins/formatter.lua` : Gère le **formatage manuel** (`Space + f + f`) avec `conform.nvim`. 🧹
2.  `lua/plugins/tools.lua` : Centralise **CMake** (`Space + c`) et le **Terminal** (`Space + t`). 🛠️🚀
3.  `lua/plugins/tasks.lua` : Gestionnaire de tâches **Just / Overseer** (`Space + j`). 🏗️🚀

## 🏹 Améliorations de l'Expérience Utilisateur (UX)

- **Arrow Keys Fix** : `ttimeoutlen = 50` dans `init.lua`. Fini les caractères 'A' ou 'B' parasites lors du mouvement. ✅
- **Smart-Close (`Space + x`)** : Intelligent ! Il ferme la console CMake ou le Quickfix sans toucher à ton fichier source. ✅
- **Dashboard Connecté** : Les boutons du menu d'accueil réveillent enfin Telescope et Neo-tree via le `lazy-loading`. ✅

## 🦀 Le Workflow C/C++ (Distrobox)

- **PathMappings** : Argument `--path-mappings=/home/latty=/var/home/latty`.
- **Utilité** : Indispensable pour que le `gr` (References) et le `rn` (Rename) fonctionnent entre le container (compilation) et l'hôte (édition).
- **CMake Focus** : Les raccourcis de build (`cb`) sautent maintenant automatiquement dans le terminal pour te montrer les logs.

## 🛠️ Just & Tasks (Projet)

Fini le terminal externe ! Gestion intégrée via **Overseer.nvim**.

| Raccourci           | Action           | Détails                                                      |
| :------------------ | :--------------- | :----------------------------------------------------------- |
| **`space + j + r`** | **Just Recipes** | Affiche la liste, lance et **ouvre le terminal** horizontal. |
| **`space + j + o`** | **Task Panel**   | Ouvre/Ferme le panneau de gestion (Droite). ✨               |
| **`space + j + l`** | **Run Last**     | Relance instantanément la dernière tâche effectuée. 🏎️       |

> [!TIP]
> **Smart-Close** : Le terminal de build se ferme **automatiquement** après 1,5s si la tâche réussit (exit 0). S'il y a une erreur, il reste ouvert pour analyse ! 🏹✅🛑

---

_Dernière mise à jour : 04 Avril 2026. Statut : Stable, Documenté & Just-Ready._
