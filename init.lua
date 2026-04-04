-- ========================================================================== --
--                  CONFIGURATION NEOVIM "VSCODE STYLE"                       --
-- ========================================================================== --

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

-- Copier (Ctrl+C en mode visuel)
key("v", "<C-c>", '"+y', { desc = "Copier vers presse-papier" })

-- Coller (Ctrl+V)
key({ "n", "v" }, "<C-v>", '"+p', { desc = "Coller depuis presse-papier" })
key("i", "<C-v>", "<C-r>+", { desc = "Coller depuis presse-papier (insert)" })

-- Sélection avec Maj + Flèches (comme dans tout éditeur moderne)
key("n", "<S-Up>", "v<Up>", { desc = "Sélection vers le haut" })
key("n", "<S-Down>", "v<Down>", { desc = "Sélection vers le bas" })
key("n", "<S-Left>", "v<Left>", { desc = "Sélection vers la gauche" })
key("n", "<S-Right>", "v<Right>", { desc = "Sélection vers la droite" })

key("v", "<S-Up>", "<Up>", { desc = "Étendre sélection haut" })
key("v", "<S-Down>", "<Down>", { desc = "Étendre sélection bas" })
key("v", "<S-Left>", "<Left>", { desc = "Étendre sélection gauche" })
key("v", "<S-Right>", "<Right>", { desc = "Étendre sélection droite" })

-- Visual Block (Comme Ctrl+V est pris pour "Coller", on utilise Ctrl+Q)
key("n", "<C-q>", "<C-v>", { desc = "Mode Visual Block" })

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
		-- Les plugins seront ajoutés ici étape par étape
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
})

-- Fin du fichier init.lua
