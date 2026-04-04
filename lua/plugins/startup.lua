-- ========================================================================== --
--                  PLUGINS : ÉCRAN D'ACCUEIL + AIDE AUX RACCOURCIS           --
-- ========================================================================== --

return {

	-- ======================================================================
	-- 1. ALPHA-NVIM : Écran d'accueil au démarrage
	-- Affiche un dashboard avec les raccourcis et les actions rapides
	-- S'affiche uniquement si nvim est lancé sans argument (nvim seul)
	-- ======================================================================
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Logo ASCII
			dashboard.section.header.val = {
				"                                                     ",
				"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
				"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
				"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
				"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
				"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
				"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
				"                   Style VSCode — Config Perso         ",
			}

			-- Boutons d'action rapide
			dashboard.section.buttons.val = {
				dashboard.button("n", "󰈔  Nouveau fichier",                    ":ene <BAR> startinsert <CR>"),
				dashboard.button("e", "  Arborescence de fichiers",            ":Neotree toggle<CR>"),
				dashboard.button("r", "  Fichiers récents",                    ":browse oldfiles<CR>"),
				dashboard.button("l", "󰒲  Lazy — Gérer les plugins",           ":Lazy<CR>"),
				dashboard.button("c", "  Configuration (init.lua)",            ":e $MYVIMRC<CR>"),
				dashboard.button("q", "  Quitter",                             ":qa<CR>"),
			}

			-- Cheat Sheet des raccourcis
			local cheatsheet_lines = {
				"",
				"  ╔══════════════════════════════════════════════════════════╗",
				"  ║              ⌨   Raccourcis Clavier Essentiels           ║",
				"  ╠══════════════════════════════════════════════════════════╣",
				"  ║  Ctrl+S            Sauvegarder                          ║",
				"  ║  Ctrl+C / Ctrl+V   Copier / Coller (presse-papier sys.) ║",
				"  ║  Ctrl+B            Toggle File Tree                     ║",
				"  ║  Ctrl+H / Ctrl+L   Fenêtre gauche / droite              ║",
				"  ║  Ctrl+J / Ctrl+K   Fenêtre bas / haut                   ║",
				"  ║  Shift+Flèches     Sélection caractère par caractère    ║",
				"  ║  Ctrl+Flèches      Saut par mot / paragraphe            ║",
				"  ║  Ctrl+Shift+Flèch  Sélection par mot / paragraphe      ║",
				"  ║  Ctrl+Q            Visual Block (sélection rect.)       ║",
				"  ║  Space + e         Révéler fichier dans File Tree       ║",
				"  ║  Space + Shift+R   Recharger la config à chaud         ║",
				"  ║  Space (+ attente) Afficher tous les raccourcis Leader  ║",
				"  ╚══════════════════════════════════════════════════════════╝",
			}

			local cheatsheet = {
				type = "text",
				val = cheatsheet_lines,
				opts = {
					position = "center",
					hl = "Comment",
				},
			}

			-- Footer : version Neovim
			dashboard.section.footer.val = string.format(
				"⚡ Neovim %d.%d.%d  |  lazy.nvim",
				vim.version().major, vim.version().minor, vim.version().patch
			)
			dashboard.section.footer.opts.hl = "AlphaFooter"

			-- Layout final
			alpha.setup({
				layout = {
					{ type = "padding", val = 2 },
					dashboard.section.header,
					{ type = "padding", val = 1 },
					dashboard.section.buttons,
					{ type = "padding", val = 1 },
					cheatsheet,
					{ type = "padding", val = 1 },
					dashboard.section.footer,
				},
			})
		end,
	},

	-- ======================================================================
	-- 2. WHICH-KEY : Popup dynamique des raccourcis
	-- Appuie sur Space (ou tout préfixe) et attends 400ms → liste des combos dispo
	-- Indispensable pour découvrir et mémoriser les raccourcis Leader
	-- ======================================================================
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
				delay = 400, -- ms avant affichage du popup
				icons = { mappings = true },
				spec = {
					-- Groupes nommés pour les raccourcis Leader
					{ "<leader>e", desc = "Révéler dans File Tree" },
					{ "<leader>R", desc = "Recharger la config" },
				},
			})
		end,
	},
}
