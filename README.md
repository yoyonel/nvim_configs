# 🚀 Neovim Config — Style VSCode

Configuration Neovim moderne, inspirée de VSCode, construite étape par étape.
Basée sur **Lua** et le gestionnaire de plugins **[Lazy.nvim](https://github.com/folke/lazy.nvim)**.

---

## Environnement cible

- OS : Linux (testé sur Bazzite / Fedora)
- Neovim : v0.12+
- Terminal : Ptyxis / tout terminal compatible 256 couleurs + truecolor

---

## 🔧 Installation rapide (autre poste)

```bash
# 1. (Optionnel) Sauvegarder une éventuelle config existante
mv ~/.config/nvim ~/.config/nvim.bak

# 2. Cloner ce dépôt directement comme config nvim
git clone <URL_DU_REPO> ~/.config/nvim

# 3. Lancer Neovim — Lazy.nvim s'installe automatiquement au premier démarrage
nvim
```

> **Note :** Le dossier cloné devient directement `~/.config/nvim`.  
> Si tu veux travailler depuis un dossier séparé (ex: `~/Prog/nvim_configs`), crée un lien symbolique :
> ```bash
> ln -s /chemin/vers/nvim_configs ~/.config/nvim
> ```

---

## 📁 Structure du projet

```
nvim_configs/
├── init.lua            # Point d'entrée (options, keymaps, bootstrap Lazy)
├── lua/
│   └── plugins/
│       ├── ui.lua          # Thème Catppuccin + Statusline Lualine
│       └── filetree.lua    # File Tree (Neo-tree)
├── lazy-lock.json      # Versions verrouillées des plugins (généré auto)
└── README.md           # Ce fichier
```

> Chaque étape ajoute un fichier dans `lua/plugins/` — `init.lua` reste propre et minimal.

---

## ⚙️ Réglages de base (`init.lua`)

| Option | Valeur | Effet |
|--------|--------|-------|
| `clipboard` | `unnamedplus` | Presse-papier partagé avec le système (Ctrl+C/V fonctionne) |
| `mouse` | `a` | Souris activée partout (défilement, clic) |
| `number` | `true` | Numéro de ligne affiché |
| `relativenumber` | `true` | Numéros relatifs sur les autres lignes |
| `cursorline` | `true` | Ligne courante mise en évidence |
| `termguicolors` | `true` | Couleurs 24-bit (obligatoire pour les thèmes modernes) |
| `tabstop` / `shiftwidth` | `4` | Indentation à 4 espaces |
| `expandtab` | `true` | Utilise des espaces, pas des tabulations |
| `ignorecase` + `smartcase` | `true` | Recherche insensible à la casse (sauf si maj présentes) |
| `updatetime` | `250` ms | Réactivité améliorée (pour les LSP, etc.) |
| `timeoutlen` | `300` ms | Délai des séquences de touches |
| `mapleader` | `Space` | Touche Leader = Espace |

---

## ⌨️ Raccourcis clavier

### Raccourcis "VSCode-like"

| Raccourci | Mode | Action |
|-----------|------|--------|
| `Ctrl + S` | Normal / Insert / Visuel | Sauvegarder le fichier |
| `Ctrl + C` | Visuel | Copier la sélection vers le presse-papier système |
| `Ctrl + V` | Normal / Visuel / Insert | Coller depuis le presse-papier système |
| `Shift + ↑/↓/←/→` | Normal | Commencer une sélection caractère par caractère |
| `Shift + ↑/↓/←/→` | Visuel | Étendre la sélection caractère par caractère |
| `↑/↓/←/→` (sans Shift) | Visuel | **Annuler la sélection** et déplacer le curseur |
| `Ctrl + ←/→` | Normal / Visuel | Sauter au mot précédent / suivant |
| `Ctrl + ↑/↓` | Normal / Visuel | Sauter au paragraphe précédent / suivant |
| `Ctrl + Shift + ←/→` | Normal | Commencer une sélection mot par mot |
| `Ctrl + Shift + ↑/↓` | Normal | Commencer une sélection jusqu'au paragraphe |
| `Ctrl + Shift + ←/→/↑/↓` | Visuel | Étendre la sélection mot par mot / paragraphe |
| `Ctrl + Q` | Normal | Mode Visual Block (sélection rectangulaire colonne) |
| `Space` puis `Shift+R` | Normal | **Recharger la config à chaud** (sans relancer nvim) |

> **Comportement VSCode :** Relâcher `Shift` et appuyer sur une flèche seule annule la sélection.

> **Pourquoi `Ctrl+Q` pour le bloc ?**  
> `Ctrl+V` étant réservé pour "Coller", on utilise `Ctrl+Q` comme alias pour le mode Visual Block natif de Vim.

> **Rechargement (`Space` → `Shift+R`) :** La touche Leader est `Space`. Le raccourci se saisit en **deux temps** : appuyer sur `Space`, relâcher, puis appuyer sur `R` (majuscule = `Shift+R`), le tout dans les 300ms. Uniquement disponible en mode **Normal** (`Esc` si tu es en Insert). Invalide le cache `lua/plugins/` et re-source `init.lua`. Pour réinstaller/mettre à jour les plugins, utiliser `:Lazy sync`.

### Navigation entre fenêtres (File Tree ↔ Éditeur ↔ Splits)

> Néovim gère plusieurs **fenêtres** (splits) simultanément. Ces raccourcis permettent de basculer entre le File Tree et l'éditeur, ou entre plusieurs splits ouverts.

| Raccourci | Action |
|-----------|--------|
| `Ctrl + H` | Aller à la fenêtre de **gauche** (ex: éditeur → File Tree) |
| `Ctrl + L` | Aller à la fenêtre de **droite** (ex: File Tree → éditeur) |
| `Ctrl + J` | Aller à la fenêtre du **bas** |
| `Ctrl + K` | Aller à la fenêtre du **haut** |

> Ces raccourcis sont des alias de `Ctrl+W` + `h/j/k/l` (navigation native Vim entre splits).  
> Ils fonctionnent quelle que soit la fenêtre active, y compris depuis Neo-tree.

---

## 📦 Plugins installés

### Étape 1 — Fondation
*(Aucun plugin — uniquement la configuration de base)*

### Étape 2 — Thème visuel (`lua/plugins/ui.lua`)

| Plugin | Rôle |
|--------|------|
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Colorscheme sombre moderne (flavour: `mocha`) |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline style Powerline/VSCode |
| [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | Icônes de fichiers (dépendance Lualine) |

> ⚠️ **Nerd Font requise** pour les icônes et les séparateurs Lualine.  
> Recommandé : [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) ou `FiraCode Nerd Font`.  
> Dans Ptyxis : *Préférences → Profil → Police*, choisir la Nerd Font installée.
### Étape 3 — Arborescence de fichiers (`lua/plugins/filetree.lua`)

| Plugin | Rôle |
|--------|------|
| [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File tree style VSCode |
| [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Utilitaires Lua (dépendance) |
| [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim) | Composants UI (dépendance) |

#### Raccourcis dans Neo-tree

| Raccourci | Action |
|-----------|--------|
| `Ctrl + B` | Toggle le panneau (ouvrir / fermer) |
| `Space + e` | Ouvrir et révéler le fichier courant dans l'arbre |
| `Entrée` ou `o` ou `l` | Ouvrir le fichier / déplier le dossier |
| `h` | Replier le dossier |
| `v` | Ouvrir dans un split vertical |
| `s` | Ouvrir dans un split horizontal |
| `a` | Nouveau fichier |
| `A` | Nouveau dossier |
| `r` | Renommer |
| `d` | Supprimer |
| `y` / `x` / `p` | Copier / Couper / Coller |
| `q` | Fermer le panneau |
| `?` | Aide (liste des mappings) |


---

## 🗺️ Roadmap

- [x] **Étape 1** : Bootstrap Lazy.nvim + réglages de base + keymaps (Ctrl+S/C/V, sélection, rechargement)
- [x] **Étape 2** : Thème visuel (Catppuccin) + statusline (Lualine)
- [x] **Étape 3** : Arborescence de fichiers (Neo-tree, Ctrl+B)
- [ ] **Étape 4** : Gestion des onglets / buffers
- [ ] **Étape 5** : Fuzzy Finder (Quick Open Ctrl+P, recherche textuelle)
- [ ] **Étape 6** : Highlighting syntaxique (Treesitter)
- [ ] **Étape 7** : LSP (Analyse statique, autocomplétion) — C/C++, Rust, Go, Python...
- [ ] **Étape 8** : Débogueur (DAP — gdb, etc.)
- [ ] **Étape 9** : Outils associés (CMake, UV/Ruff, formatters)
