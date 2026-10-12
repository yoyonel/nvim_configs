# 🚀 Neovim Config — Style VSCode

Configuration Neovim moderne, inspirée de VSCode, construite étape par étape.
Basée sur **Lua** et le gestionnaire de plugins **[Lazy.nvim](https://github.com/folke/lazy.nvim)**.

---

## Environnement cible

- OS : Linux (testé sur Bazzite / Fedora)
- Neovim : v0.12+
- Terminal : Ptyxis / tout terminal compatible 256 couleurs + truecolor

---

## 🔧 Installation & Déploiement

### Déploiement via Taskfile (Recommandé)

```bash
# 1. Cloner ce dépôt
git clone <URL_DU_REPO> ~/Prog/__PERSO__/nvim_configs
cd ~/Prog/__PERSO__/nvim_configs

# 2. Lier symboliquement vers ~/.config/nvim (sauvegarde auto si dossier existant)
task host:link

# 3. Valider l'intégrité de la configuration et des dépendances
task check
```

### Installation directe (Autre poste sans Task)

```bash
# 1. (Optionnel) Sauvegarder une éventuelle config existante
mv ~/.config/nvim ~/.config/nvim.bak

# 2. Cloner ce dépôt directement comme config nvim
git clone <URL_DU_REPO> ~/.config/nvim

# 3. Lancer Neovim — Lazy.nvim s'installe automatiquement au premier démarrage
nvim
```

---

## 📁 Structure du projet

```
nvim_configs/
├── init.lua            # Point d'entrée (options, keymaps, bootstrap Lazy)
├── lua/
│   └── plugins/
│       ├── ui.lua          # Thème Catppuccin + Statusline Lualine
│       ├── filetree.lua    # File Tree (Neo-tree, Ctrl+B)
│       ├── startup.lua     # Écran d'accueil + Aide raccourcis (Alpha-nvim)
│       ├── bufferline.lua  # Onglets / Buffers (barre du haut)
│       ├── telescope.lua   # Fuzzy Finder (Ctrl+P, recherche globale)
│       ├── treesitter.lua  # Coloration syntaxique + sélection intelligente
│       ├── lsp.lua         # Intelligence de code (Definitions, Autocomplete)
│       ├── debug.lua       # Débogueur DAP (gdb, lldb)
│       ├── formatter.lua   # Formatage automatique (conform.nvim)
│       ├── git.lua         # Git & 3-way merge diff (Diffview, Gitsigns)
│       ├── tasks.lua       # Gestionnaire de tâches (Overseer)
│       └── tools.lua       # Terminal flottant & CMake tools
├── scripts/
│   ├── capture_x11.sh  # Capture d'écran X11 automatisée (test visuel UI)
│   ├── install_host.sh # Déploiement / Synchronisation / Symlink hôte
│   ├── test_render.py  # Test unitaire de rendu PTY anti-régression
│   └── validate.sh     # Validation syntaxe Lua et démarrage headless
├── Taskfile.yml        # Automatisation des tâches (Task)
├── Justfile            # Runner Just alternatif
├── lazy-lock.json      # Versions verrouillées des plugins (généré auto)
└── README.md           # Ce fichier
```

> Chaque étape ajoute un fichier dans `lua/plugins/` — `init.lua` reste propre et minimal.

---

## ⚙️ Réglages de base (`init.lua`)

| Option                     | Valeur        | Effet                                                       |
| -------------------------- | ------------- | ----------------------------------------------------------- |
| `clipboard`                | `unnamedplus` | Presse-papier partagé avec le système (Ctrl+C/V fonctionne) |
| `mouse`                    | `a`           | Souris activée partout (défilement, clic)                   |
| `number`                   | `true`        | Numéro de ligne affiché                                     |
| `relativenumber`           | `true`        | Numéros relatifs sur les autres lignes                      |
| `cursorline`               | `true`        | Ligne courante mise en évidence                             |
| `termguicolors`            | `true`        | Couleurs 24-bit (obligatoire pour les thèmes modernes)      |
| `tabstop` / `shiftwidth`   | `4`           | Indentation à 4 espaces                                     |
| `expandtab`                | `true`        | Utilise des espaces, pas des tabulations                    |
| `ignorecase` + `smartcase` | `true`        | Recherche insensible à la casse (sauf si maj présentes)     |
| `updatetime`               | `250` ms      | Réactivité améliorée (pour les LSP, etc.)                   |
| `timeoutlen`               | `300` ms      | Délai des séquences de touches                              |
| `mapleader`                | `Space`       | Touche Leader = Espace                                      |

---

## ⌨️ Raccourcis clavier

### Raccourcis "VSCode-like"

| Raccourci                | Mode                     | Action                                               |
| ------------------------ | ------------------------ | ---------------------------------------------------- |
| `Ctrl + S`               | Normal / Insert / Visuel | Sauvegarder le fichier                               |
| `Ctrl + C`               | Visuel                   | Copier la sélection vers le presse-papier système    |
| `Ctrl + V`               | Normal / Visuel / Insert | Coller depuis le presse-papier système               |
| `Shift + ↑/↓/←/→`        | Normal                   | Commencer une sélection caractère par caractère      |
| `Shift + ↑/↓/←/→`        | Visuel                   | Étendre la sélection caractère par caractère         |
| `↑/↓/←/→` (sans Shift)   | Visuel                   | **Annuler la sélection** et déplacer le curseur      |
| `Ctrl + ←/→`             | Normal / Visuel          | Sauter au mot précédent / suivant                    |
| `Ctrl + ↑/↓`             | Normal / Visuel          | Sauter au paragraphe précédent / suivant             |
| `Ctrl + Shift + ←/→`     | Normal                   | Commencer une sélection mot par mot                  |
| `Ctrl + Shift + ↑/↓`     | Normal                   | Commencer une sélection jusqu'au paragraphe          |
| `Ctrl + Shift + ←/→/↑/↓` | Visuel                   | Étendre la sélection mot par mot / paragraphe        |
| `Ctrl + Q`               | Normal                   | Mode Visual Block (sélection rectangulaire colonne)  |
| `Space` puis `Shift+R`   | Normal                   | **Recharger la config à chaud** (sans relancer nvim) |

> **Comportement VSCode :** Relâcher `Shift` et appuyer sur une flèche seule annule la sélection.

> **Pourquoi `Ctrl+Q` pour le bloc ?**  
> `Ctrl+V` étant réservé pour "Coller", on utilise `Ctrl+Q` comme alias pour le mode Visual Block natif de Vim.

> **Rechargement (`Space` → `Shift+R`) :** La touche Leader est `Space`. Le raccourci se saisit en **deux temps** : appuyer sur `Space`, relâcher, puis appuyer sur `R` (majuscule = `Shift+R`), le tout dans les 300ms. Uniquement disponible en mode **Normal** (`Esc` si tu es en Insert). Invalide le cache `lua/plugins/` et re-source `init.lua`. Pour réinstaller/mettre à jour les plugins, utiliser `:Lazy sync`.

### Navigation entre fenêtres (File Tree ↔ Éditeur ↔ Splits)

> Néovim gère plusieurs **fenêtres** (splits) simultanément. Ces raccourcis permettent de basculer entre le File Tree et l'éditeur, ou entre plusieurs splits ouverts.

| Raccourci  | Action                                                     |
| ---------- | ---------------------------------------------------------- |
| `Ctrl + H` | Aller à la fenêtre de **gauche** (ex: éditeur → File Tree) |
| `Ctrl + L` | Aller à la fenêtre de **droite** (ex: File Tree → éditeur) |
| `Ctrl + J` | Aller à la fenêtre du **bas**                              |
| `Ctrl + K` | Aller à la fenêtre du **haut**                             |

> Ces raccourcis sont des alias de `Ctrl+W` + `h/j/k/l` (navigation native Vim entre splits).  
> Ils fonctionnent quelle que soit la fenêtre active, y compris depuis Neo-tree.

---

## 📦 Plugins installés

### Étape 1 — Fondation

_(Aucun plugin — uniquement la configuration de base)_

### Étape 2 — Thème visuel (`lua/plugins/ui.lua`)

| Plugin                                                                        | Rôle                                          |
| ----------------------------------------------------------------------------- | --------------------------------------------- |
| [catppuccin/nvim](https://github.com/catppuccin/nvim)                         | Colorscheme sombre moderne (flavour: `mocha`) |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)     | Statusline style Powerline/VSCode             |
| [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | Icônes de fichiers (dépendance Lualine)       |

> ⚠️ **Nerd Font requise** pour les icônes et les séparateurs Lualine.  
> Recommandé : [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) ou `FiraCode Nerd Font`.  
> Dans Ptyxis : _Préférences → Profil → Police_, choisir la Nerd Font installée.

### Étape 3 — Arborescence de fichiers (`lua/plugins/filetree.lua`)

| Plugin                                                                        | Rôle                         |
| ----------------------------------------------------------------------------- | ---------------------------- |
| [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File tree style VSCode       |
| [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)             | Utilitaires Lua (dépendance) |
| [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)               | Composants UI (dépendance)   |

#### Raccourcis dans Neo-tree

| Raccourci              | Action                                            |
| ---------------------- | ------------------------------------------------- |
| `Ctrl + B`             | Toggle le panneau (ouvrir / fermer)               |
| `Space + e`            | Ouvrir et révéler le fichier courant dans l'arbre |
| `Entrée` ou `o` ou `l` | Ouvrir le fichier / déplier le dossier            |
| `h`                    | Replier le dossier                                |
| `v`                    | Ouvrir dans un split vertical                     |
| `s`                    | Ouvrir dans un split horizontal                   |
| `a`                    | Nouveau fichier                                   |
| `A`                    | Nouveau dossier                                   |
| `r`                    | Renommer                                          |
| `d`                    | Supprimer                                         |
| `y` / `x` / `p`        | Copier / Couper / Coller                          |
| `q`                    | Fermer le panneau                                 |
| `?`                    | Aide (liste des mappings)                         |

### Étape 3.1 — Aide et Démarrage (`lua/plugins/startup.lua`)

| Plugin                                                          | Rôle                                       |
| --------------------------------------------------------------- | ------------------------------------------ |
| [goolord/alpha-nvim](https://github.com/goolord/alpha-nvim)     | Dashboard au démarrage avec Cheat Sheet    |
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | Popup d'aide dynamique pour les raccourcis |

#### Utilisation

- **Dashboard** : S'affiche au lancement de `nvim` sans fichier. Appuyer sur une touche (`n`, `e`, etc.) pour l'action correspondante.
- **Which-Key** : Appuyer sur `Space` (Leader) et attendre 400ms pour voir apparaître la liste des commandes disponibles.

---

## 🛠️ Outillage du projet (Qualité & CI)

Le repo est instrumenté pour garantir une configuration stable, propre et performante. Tout est centralisé via le **[Justfile](https://github.com/casey/just)**.

### 1. Commandes de maintenance (`just`)

Utilise `just` à la racine pour piloter les outils internes :

| Commande        | Action                                                                        |
| --------------- | ----------------------------------------------------------------------------- |
| `just validate` | Lance `./scripts/validate.sh` (Syntaxe Lua + test de démarrage Clean).        |
| `just lint`     | Vérifie le formatage et la qualité (Lua, MD, JSON, YAML) sans modifier.       |
| **`just fmt`**  | **Formatage automatique** de tous les fichiers du projet (Stylua + Prettier). |
| `just sync`     | Synchronise les plugins Neovim (Lazy) en mode headless.                       |

> **Note sur le formatage :** `just fmt` utilise automatiquement le binaire `stylua` installé par Mason dans ta config Neovim. Pour les autres formats, il utilise `npx prettier` (nécessite Node.js).

### 2. Intégration Continue (GitHub Actions)

À chaque `push` ou `pull request`, le workflow `.github/workflows/ci.yml` s'exécute sur Ubuntu :

- Installation de Neovim, Just et Stylua.
- Exécution de `just validate` pour garantir que la config démarre.
- Exécution de `just lint` pour vérifier la propreté du code.

### Étape 4 — Onglets et Buffers (`lua/plugins/bufferline.lua`)

| Plugin                                                                | Rôle                            |
| --------------------------------------------------------------------- | ------------------------------- |
| [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Barre d'onglets moderne en haut |

#### Raccourcis de navigation (Onglets)

| Raccourci                | Action                                           |
| ------------------------ | ------------------------------------------------ |
| `Shift + H` ou `Alt + ←` | Aller à l'onglet précédent                       |
| `Shift + L` ou `Alt + →` | Aller à l'onglet suivant                         |
| `Alt + [1-9]`            | Aller directement à l'onglet 1-9                 |
| `Ctrl+Alt + ←/→`         | Déplacer l'onglet actuel vers la gauche/droite   |
| `Space + w`              | Fermer l'onglet courant (garder le split ouvert) |
| `Space + x`              | Fermer le buffer/onglet actuel                   |
| `Clic gauche`            | Sélectionner l'onglet                            |
| `Clic droit`             | Fermer l'onglet                                  |

### Étape 5 — Fuzzy Finder (`lua/plugins/telescope.lua`)

| Plugin                                                                                                  | Rôle                                  |
| ------------------------------------------------------------------------------------------------------- | ------------------------------------- |
| [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                       | Moteur de recherche multimode         |
| [nvim-telescope/telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Extension native C pour fzf (vitesse) |

#### Raccourcis de recherche (Telescope)

| Raccourci       | Action                                                |
| --------------- | ----------------------------------------------------- |
| `Ctrl + P`      | **Quick Open** : chercher un fichier par son nom      |
| `Space + f + g` | **Live Grep** : chercher un texte dans tout le projet |
| `Space + f + b` | Chercher parmi les buffers ouverts                    |
| `Space + f + r` | Chercher dans l'historique des fichiers récents       |
| `Space + f + h` | Chercher dans l'aide Neovim                           |

> **Note :** Live Grep nécessite `ripgrep` (`rg`) installé sur le système.

### Étape 6 — Analyse Syntaxique (`lua/plugins/treesitter.lua`)

| Plugin                                                                                | Rôle                                    |
| ------------------------------------------------------------------------------------- | --------------------------------------- |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Coloration syntaxique AST + Indentation |

#### Raccourcis de sélection (Treesitter)

| Raccourci            | Action                                                               |
| -------------------- | -------------------------------------------------------------------- |
| `Ctrl + Espace`      | **Smart Selection** : étendre la sélection au bloc logique supérieur |
| `Retour (Backspace)` | Réduire la sélection intelligente                                    |

> **Note :** Treesitter nécessite un compilateur C (`gcc`, `clang`) et `make` pour installer les parsers.  
> Commande utile : `:TSUpdate` pour mettre à jour manuellement.

### Étape 7 — Intelligence de code (LSP) (`lua/plugins/lsp.lua`)

| Plugin                                                                | Rôle                            |
| --------------------------------------------------------------------- | ------------------------------- |
| [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) | Gestionnaire de binaires (Hôte) |
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)     | Pont de configuration LSP       |
| [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)               | Moteur d'autocomplétion         |

#### Raccourcis LSP (Navigation & Aide)

| Raccourci       | Action                                                        |
| --------------- | ------------------------------------------------------------- |
| `g + d`         | **Go to Definition** : sauter à la définition du symbole      |
| `g + r`         | **Go to References** : voir tous les usages (dans Telescope)  |
| `K`             | **Hover** : afficher la documentation de la fonction/variable |
| `Space + r + n` | **Rename** : Renommer le symbole dans tout le projet          |
| `Space + c + a` | **Code Action** : afficher les corrections rapides            |
| `Space + d`     | Afficher l'erreur de la ligne actuelle en flottant            |
| `[` / `]` + `d` | Erreur précédente / suivante                                  |

#### Autocomplétion (En mode Insert)

| Raccourci       | Action                                 |
| --------------- | -------------------------------------- |
| `Tab`           | Parcourir les suggestions              |
| `Entrée`        | Valider la suggestion                  |
| `Ctrl + j/k`    | Monter / Descendre dans la liste       |
| `Ctrl + Espace` | Forcer l'affichage de l'autocomplétion |

### Étape 8 — Débogueur (DAP) (`lua/plugins/debug.lua`)

| Plugin                                                                                | Rôle                                             |
| ------------------------------------------------------------------------------------- | ------------------------------------------------ |
| [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)                     | Moteur de debug (Debug Adapter Protocol)         |
| [rcarriga/nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)                       | Interface visuelle avec panneaux (Stack/Var)     |
| [theHamsta/nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text) | Valeurs des variables affichées en bout de ligne |

#### Raccourcis de Debug (Standard IDE)

| Raccourci       | Action                     | Description                            |
| --------------- | -------------------------- | -------------------------------------- |
| `F5`            | Continuer / Start          | Démarre ou poursuit l'exécution.       |
| `F10`           | Pas à pas (Step Over)      | Saute à la ligne suivante.             |
| `F11`           | Entrer (Step Into)         | Entre dans la fonction.                |
| `F12`           | Sortir (Step Out)          | Finit la fonction actuelle.            |
| `Space + b`     | Toggle Breakpoint          | Place 🔴 ou retire un point d'arrêt.   |
| `Space + B`     | Point d'arrêt conditionnel | Demande une condition pour s'arrêter.  |
| `Space + d + u` | Toggle DAP UI              | Ouvre/ferme manuellement les panneaux. |

---

## 🛠️ Automatisation & Tâches (`Taskfile.yml`)

Le projet utilise [go-task](https://taskfile.dev) (`task`) pour automatiser les tests, le linting, le déploiement hôte et la validation visuelle :

| Commande              | Action                         | Description                                                                     |
| :-------------------- | :----------------------------- | :------------------------------------------------------------------------------ |
| `task check`          | Suite complète                 | Exécute `validate` + `lint` + `test:render` + `host:status`                     |
| `task validate`       | Validation syntaxe & démarrage | Vérifie la syntaxe Lua et démarre Neovim headless sans erreur                   |
| `task lint`           | Contrôle de style              | Vérifie le formatage avec `stylua` et `prettier` sans modifier                  |
| `task fmt`            | Formatage automatique          | Nettoie et applique le formatage `stylua` et `prettier`                         |
| `task test:render`    | Test anti-régression PTY       | Test automatisé sous PTY vérifiant l'absence de vidéo inverse / artefacts       |
| `task capture:x11`    | Capture visuelle X11           | Lance Neovim dans Alacritty et prend une capture d'écran PNG                    |
| `task host:status`    | Statut de synchronisation      | Indique si `~/.config/nvim` est un symlink ou un dossier physique désynchronisé |
| `task host:link`      | Lien symbolique hôte           | Crée le lien `~/.config/nvim -> nvim_configs` (avec backup auto horodaté)       |
| `task host:sync`      | Déploiement `rsync`            | Synchronise le contenu du dépôt vers `~/.config/nvim`                           |
| `task host:diff`      | Comparaison hôte               | Affiche le `diff` entre le dossier de dev et `~/.config/nvim`                   |
| `task plugins:sync`   | Sync plugins Lazy              | Synchronise et installe les plugins en mode headless                            |
| `task plugins:update` | MAJ plugins Lazy               | Met à jour l'ensemble des plugins Lazy                                          |
| `task plugins:clean`  | Nettoyage Lazy                 | Supprime les plugins orphelins                                                  |

---

## 🗺️ Roadmap

- [x] **Étape 1** : Bootstrap Lazy.nvim + réglages de base + keymaps (Ctrl+S/C/V, sélection, rechargement)
- [x] **Étape 2** : Thème visuel (Catppuccin) + statusline (Lualine)
- [x] **Étape 3** : Arborescence de fichiers (Neo-tree, Ctrl+B)
- [x] **Étape 4** : Gestion des onglets / buffers (Bufferline)
- [x] **Étape 5** : Fuzzy Finder (Telescope, Ctrl+P, recherche textuelle)
- [x] **Étape 6** : Highlighting syntaxique (Treesitter, Ctrl+Espace)
- [x] **Étape 7** : LSP (Analyse statique, autocomplétion) — C/C++, Rust, Go, Python...
- [x] **Étape 8** : Débogueur (DAP — gdb, etc.)
- [ ] **Étape 9** : Outils associés (CMake, UV/Ruff, formatters)
