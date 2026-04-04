-- ========================================================================== --
--                  CONFIGURATION NEOVIM "VSCODE STYLE"                       --
-- ========================================================================== --

-- On neutralise les warnings de dépréciation
vim.deprecate = function() end

-- Silence sur les notifications dépréciées (LSP, etc)
vim.notify = function(msg, level, opts)
	if msg:match("deprecated") or msg:match("lspconfig") then return end
	-- Utilisation de la notification standard si pas de match
	return vim.api.nvim_echo({{msg, "None"}}, true, {})
end

-- Délais pour les séquences de touches (Fix flèches 'A', 'B'...)
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 50

-- 1. OPTIONS DE BASE (Le ressenti "IDE")
-- -------------------------------------------------------------------------- --
vim.g.mapleader = " " -- Définir l'espace comme touche Leader
vim.g.maplocalleader = " "

-- Presse-papier système (Indispensable pour copier/coller en dehors de NVim)
vim.opt.clipboard = "unnamedplus"

-- Activation de la souris (partout)
vim.opt.mouse = "a"

-- Numérotation des lignes (Relative pour le mouvement, Absolue pour la position)
vim.opt.number = true
vim.opt.relativenumber = true

-- Recherche intelligente
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Temps de réponse (pour les raccourcis complexes)
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.hidden = true   -- Permet de naviguer entre fichiers sans sauvegarder
vim.opt.scrolloff = 8   -- Garde le curseur au centre de l'écran (vertical)

-- Indentation (Standard 4 espaces, extensible selon le langage)
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Curseur : ligne entière (VSCode soulignement de ligne)
vim.opt.cursorline = true

-- Term-GUI-Colors : Indispensable pour les thèmes modernes
vim.opt.termguicolors = true

-- 2. RACCOURCIS FAMILIERS (CTRL+C / V / S / ...)
-- -------------------------------------------------------------------------- --
local key = vim.keymap.set

-- Sauvegarde rapide (Ctrl+S)
key({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Sauvegarder" })

-- Quitter Neovim (Space + q) — Comme Ctrl+Q sur VSCode
key("n", "<leader>q", "<cmd>confirm qa<cr>", { desc = "Quitter Neovim (Tout fermer)" })
key("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Forcer la sortie (sans sauvegarder)" })


-- Navigation entre fenêtres (File Tree ↔ Éditeur ↔ Splits)
-- Equvalent de Ctrl+W + direction, mais en une seule touche
key("n", "<C-h>", "<C-w>h", { desc = "Aller à la fenêtre de gauche" })
key("n", "<C-j>", "<C-w>j", { desc = "Aller à la fenêtre du bas" })
key("n", "<C-k>", "<C-w>k", { desc = "Aller à la fenêtre du haut" })
key("n", "<C-l>", "<C-w>l", { desc = "Aller à la fenêtre de droite" })


-- Rechargement à chaud de la config (Space + Shift+R)
-- Invalide le cache des modules lua/plugins/ puis re-source init.lua
-- Conseil : utiliser :Lazy sync pour réinstaller/mettre à jour les plugins
local function reload_config()
	for name, _ in pairs(package.loaded) do
		if name:match("^plugins") then
			package.loaded[name] = nil
		end
	end
	dofile(vim.env.MYVIMRC)
	vim.notify("✅ Config rechargée !", vim.log.levels.INFO)
end
key("n", "<leader>R", reload_config, { desc = "Recharger la config Neovim" })

-- Sélectionner tout (Ctrl+A)
key({ "n", "v", "i" }, "<C-a>", "<esc>ggVG", { desc = "Tout sélectionner" })


-- Copier (Ctrl+C en mode visuel)
key({ "v", "s" }, "<C-c>", '"+y', { desc = "Copier vers presse-papier" })

-- Couper (Ctrl+X)
key({ "v", "s" }, "<C-x>", '"+d', { desc = "Couper vers presse-papier" })
key("n", "<C-x>", '"+dd', { desc = "Couper la ligne vers presse-papier" })

-- Coller (Ctrl+V)
key({ "n", "v", "s"     }, "<C-v>", '"+p', { desc = "Coller depuis presse-papier" })
key("i", "<C-v>", "<C-r>+", { desc = "Coller depuis presse-papier (insert)" })

-- Sélection avec Maj + Flèches (comme dans tout éditeur moderne)
key("n", "<S-Up>", "v<Up>", { desc = "Sélection vers le haut" })
key("n", "<S-Down>", "v<Down>", { desc = "Sélection vers le bas" })
key("n", "<S-Left>", "v<Left>", { desc = "Sélection vers la gauche" })
key("n", "<S-Right>", "v<Right>", { desc = "Sélection vers la droite" })

key("v", "<S-Up>",    "<Up>",    { desc = "Étendre sélection haut" })
key("v", "<S-Down>",  "<Down>",  { desc = "Étendre sélection bas" })
key("v", "<S-Left>",  "<Left>",  { desc = "Étendre sélection gauche" })
key("v", "<S-Right>", "<Right>", { desc = "Étendre sélection droite" })

-- Flèches seules en mode visuel : annuler la sélection et déplacer le curseur
-- (Comportement VSCode : relâcher Shift termine la sélection)
key("v", "<Up>",    "<Esc><Up>",    { desc = "Annuler sélection et aller haut" })
key("v", "<Down>",  "<Esc><Down>",  { desc = "Annuler sélection et aller bas" })
key("v", "<Left>",  "<Esc><Left>",  { desc = "Annuler sélection et aller gauche" })
key("v", "<Right>", "<Esc><Right>", { desc = "Annuler sélection et aller droite" })

-- Visual Block (Comme Ctrl+V est pris pour "Coller", on utilise Ctrl+Q)
key("n", "<C-q>", "<C-v>", { desc = "Mode Visual Block (sélection rectangulaire)" })

-- Ctrl+Flèches : Saut par mot (comme dans VSCode / tout éditeur moderne)
key({ "n", "v" }, "<C-Left>",  "b",  { desc = "Mot précédent" })
key({ "n", "v" }, "<C-Right>", "w",  { desc = "Mot suivant" })
key({ "n", "v" }, "<C-Up>",   "{",  { desc = "Paragraphe précédent" })
key({ "n", "v" }, "<C-Down>", "}",  { desc = "Paragraphe suivant" })

-- Ctrl+Shift+Flèches : Sélection mot par mot (comme dans VSCode)
-- Gauche/Droite : sélectionne le mot précédent/suivant
key("n", "<C-S-Left>",  "vb", { desc = "Sélectionner vers mot précédent" })
key("n", "<C-S-Right>", "vw", { desc = "Sélectionner vers mot suivant" })
-- Haut/Bas : sélectionne jusqu'au paragraphe précédent/suivant
key("n", "<C-S-Up>",   "v{", { desc = "Sélectionner vers paragraphe précédent" })
key("n", "<C-S-Down>", "v}", { desc = "Sélectionner vers paragraphe suivant" })

-- En mode visuel (sélection déjà active) : étendre mot à mot
key("v", "<C-S-Left>",  "b",  { desc = "Étendre sélection mot précédent" })
key("v", "<C-S-Right>", "w",  { desc = "Étendre sélection mot suivant" })
key("v", "<C-S-Up>",   "{",  { desc = "Étendre sélection paragraphe précédent" })
key("v", "<C-S-Down>", "}",  { desc = "Étendre sélection paragraphe suivant" })


-- 3. BOOTSTRAP DE LAZY.NVIM
-- -------------------------------------------------------------------------- --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Configuration de Lazy
require("lazy").setup({
	spec = {
		-- Import de tous les fichiers dans lua/plugins/
		{ import = "plugins" },
	},
	install = { colorscheme = { "catppuccin", "habamax" } },
	checker = {
		enabled = true,
		notify = false, -- Pas de popup au démarrage pour les mises à jour
	},
	change_detection = {
		notify = false, -- Pas de popup si on modifie le code de la config
	},
})

-- Fin du fichier init.lua
