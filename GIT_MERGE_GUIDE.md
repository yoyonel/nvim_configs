# 🧭 Guide de Résolution de Conflits (PyCharm ↔ Neovim)

Ce projet utilise **Diffview.nvim** pour reproduire l'expérience du "3-Way Merge" de PyCharm/IntelliJ. Voici comment s'en servir sans perdre pied. ✨📦🤖🚀🧱🏗️🦾

## 🚦 Démarrage Rapide

Dès que Git te signale un conflit lors d'un `merge` ou d'un `rebase`, lance :

```vim
:DiffviewOpen
```

## 🏗️ Structure de l'écran (3 Colonnes)

Contrairement à la vue inline de base, l'écran de merge Diffview se présente ainsi :

1. **Gauche (REMOTE)** : C'est "Theirs" (leur version, celle que tu fusionnes). 🏰
2. **Droite (LOCAL)** : C'est "Ours" (ta version, celle de ta branche active). 🏠
3. **Centre (RESULT)** : C'est le fichier final que tu es en train de construire. 🧪✨

## ⌨️ Lexique des raccourcis (PyCharm Style)

| Action PyCharm            | Équivalent Neovim         | Description                                |
| ------------------------- | ------------------------- | ------------------------------------------ |
| **Bouton "Accept Left"**  | **`<leader>gt`** (Theirs) | Prend "Theirs" (Remote / Colonne Gauche).  |
| **Bouton "Accept Right"** | **`<leader>go`** (Ours)   | Prend "Ours" (Local / Colonne Droite).     |
| **Bouton "Accept Both"**  | **`<leader>ga`** (All)    | Garde les **DEUX** versions fusionnées.    |
| **Fût "Base"**            | **`<leader>gb`** (Base)   | Prend la version commune avant le conflit. |
| **Chevron Suivant**       | **`]c`**                  | Saute au conflit suivant.                  |
| **Chevron Précédent**     | **`[c`**                  | Remonte au conflit précédent.              |

## 🛠️ Le Workflow complet (Le rituel)

1.  **Ouverture** : `:DiffviewOpen` 🏁
2.  **Navigation** : Utilise un `]c` pour arriver pile sur le premier conflit.
3.  **Choix** : Tape l'une des commandes (ex: `<leader>go`) pour injecter le code dans la colonne du milieu.
4.  **Édition** : Tu peux aussi taper manuellement tes modifs au centre si aucune option ne te convient. ✨💎
5.  **Sauvegarde** : Enregistre le fichier (`Ctrl+S`).
6.  **Stage** : Tape `s` dans le panneau de fichiers à gauche pour marquer le fichier comme résolu. ✨📦🏗️🏗️🚜🏗️🛠️🏗️
7.  **Fermeture** : `:DiffviewClose` ou tape `q`.
8.  **Commit** : Finis ton merge normalement dans ton terminal. 🏆

---

> **Note :** La touche `<leader>` est configurée sur **`Espace`**.  
> Pour "Accept Right" (Local), la séquence est donc : `Espace`, relâcher, `g`, `o`. 🚀
