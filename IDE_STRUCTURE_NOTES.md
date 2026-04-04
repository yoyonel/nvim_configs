# 🧠 Notes de Structure & Hacks (Dossier Technique)

Ce document explique les décisions architecturales et les "hacks" mis en place pour assurer la stabilité de l'IDE sur Bazzite/Distrobox, après avoir résolu les instabilités majeures rencontrées avec la version Nightly.

---

## 1. 🏆 Le Downgrade Stratégique (0.12 → 0.10.1)
**Problème** : Neovim v0.12 (Nightly) introduisait des changements d'API (notamment la suppression de `vim.treesitter.ft_to_lang`) qui faisaient crasher les prévisualiseurs de Telescope et certains plugins tiers.
**Hack** : Retour à la version **v0.10.1 Stable (AppImage)**. 
- **Bénéfice** : Stabilité totale des APIs. Tous les plugins actuels sont synchronisés sur cette branche.
- **Récupération** : Un `pcall(require, "plugin")` a été ajouté aux points critiques (ex: Treesitter) pour éviter que l'éditeur ne refuse de démarrer en cas de corruption des dossiers `lazy`.

---

## 2. 🏹 Le Workflow Just (Overseer.nvim)
C'est le cœur de l'intégration "IDE". Voici comment les problèmes ont été résolus :

### A. Le Problème de Détection
Overseer ne détectait pas toujours le `Justfile` à cause du contexte de démarrage.
- **Solution** : Dans `lua/plugins/tasks.lua`, on a forcé `templates = { 'builtin' }` mais aussi le filtrage interne dans le setup.
- **Le Hack** : On utilise `require("overseer").run_template({})` (vide) pour forcer le scan du dossier courant sans attendre une détection passive.

### B. Le Hack du "Follow" (Auto-Scroll)
**Problème** : Un terminal Neovim ne "suit" l'output que si le curseur est sur la dernière ligne.
**Fix** : Dans le raccourci `<leader>jr`, on utilise un `vim.defer_fn` qui exécute `normal! G` (Aller à la ligne finale) 50ms après l'ouverture du split. Cela "réveille" le follow natif de Neovim.

### C. Le Hack du "Smart-Close" (Fermeture Auto)
**Problème** : Le terminal reste ouvert avec le message `[Process exited 0]`, polluant l'écran après un build réussi.
**Le Hack (Chirurgical)** : 
On utilise `task:subscribe("on_complete", ...)` qui surveille le statut. 
- Si `status == "SUCCESS"`, on identifie le **Window ID** associé au buffer de la tâche via `vim.fn.win_findbuf(bufnr)`.
- On ferme uniquement ces fenêtres après un délai de 1.5s (`defer_fn`).
- **Pourquoi pas une option standard ?** Car les réglages du terminal (`quit_on_exit`) sont globaux et souvent instables sur distrobox. Ce script Lua garantit une précision au pixel près sans effet de bord.

---

## ⌨️ 3. Le Fix des "Caractères Parasites" (A, B, C, D)
**Problème** : Utiliser les flèches directionnelles générait des lettres ('A', 'B'...) au lieu de bouger le curseur.
**Cause** : Neovim n'identifiait pas assez vite la séquence d'échappement (ESC + [ + A).
**Fix** : Positionnement de `vim.o.ttimeoutlen = 50` dans `init.lua`. Cela réduit le temps d'attente pour valider une séquence clavier.

---

## 🦀 4. Mapping de Chemins (Distrobox)
**Problème** : `clangd` s'exécute dans Distrobox (`/home/latty`), mais Neovim édite depuis l'hôte (`/var/home/latty`).
**Solution** : Injection de l'argument `--path-mappings` dans la configuration LSP de `clangd` (`lua/plugins/lsp.lua`).
- **Valeur** : Permet au LSP de mapper les fichiers ouverts à leurs versions compilées, débloquant le `Go to Definition` et le `Reference Search`.

---

## 🏗️ 5. Maintenance Automatisée
Pour éviter que l'environnement ne se dégrade avec le temps :
- Un bouton **`u` (Update)** a été ajouté au Dashboard.
- Il déclenche une cascade : `Lazy sync` → `TSUpdate` → `MasonUpdate`. 
- C'est le "Reset" à faire après chaque grosse mise à jour système Bazzite ou changement de container.

---
*Document conçu pour Latty (2026-04-04).*
