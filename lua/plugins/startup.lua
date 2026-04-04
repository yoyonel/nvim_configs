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
				dashboard.button("p", "󰈔  Ouvrir Fichier (Ctrl+P)",        ":Telescope find_files<CR>"),
				dashboard.button("g", "  Chercher Texte (Grep)",           ":Telescope live_grep<CR>"),
				dashboard.button("r", "  Fichiers récents",                ":Telescope oldfiles<CR>"),
				dashboard.button("e", "  Arborescence & Statut Git (Ctrl+B)", ":Neotree toggle<CR>"),
				dashboard.button("l", "󰒲  Lazy — Gérer les plugins",       ":Lazy<CR>"),
				dashboard.button("u", "󰚰  MAJ & Réparer Système (Auto)",  ":Lazy sync | TSUpdate | MasonUpdate<CR>"),
				dashboard.button("c", "  Configuration (init.lua)",        ":e $MYVIMRC<CR>"),
				dashboard.button("q", "  Quitter (Space+Q)",               ":confirm qa<CR>"),
			}

			-- Cheat Sheet des raccourcis
			local cheatsheet_lines = {
				"",
				"  ╔══════════════════════════════════════════════════════════╗",
				"  ║              ⌨   Raccourcis Clavier Essentiels           ║",
				"  ╠══════════════════════════════════════════════════════════╣",
				"  ║  Ctrl+S            Sauvegarder                          ║",
				"  ║  Ctrl+C / X / V    Copier / Couper / Coller (presse-p.) ║",
				"  ║  Ctrl+P            Chercher un fichier (au nom)         ║",
				"  ║  Ctrl+B            Arborescence & Statut Git (M/U/A)    ║",
				"  ║  Ctrl+H / J / K / L Naviguer entre les fenêtres          ║",
				"  ║  Alt+← / Alt+→     Onglet précédent / suivant            ║",
				"  ║  ● Indicateur      Fichier ouvert avec modifications    ║",
				"  ║  Ctrl+Q            Visual Block (sélection rect.)       ║",
				"  ║  Ctrl+Espace       Smart Selection (extension bloc)     ║",
				"  ║  Space + x / q     Fermer onglet / Quitter              ║",
				"  ║  Space + f + g     Chercher texte dans le projet (Grep) ║",
				"  ║  Space + f + b     Chercher dans les buffers ouverts    ║",
				"  ║  Space + f + r     Chercher dans fichiers récents       ║",
				"  ║  Space + f + h     Chercher dans l'aide Neovim          ║",
				"  ║  gd / gr           Go to Definition / Reference         ║",
				"  ║  K                  Afficher Documentation (Hover)       ║",
				"  ║  Space + r + n     Rename (Renommer variable)           ║",
				"  ║  Space + c + a     Code Action (Quick Fix)              ║",
				"  ║  Space + Shift+R   Recharger la config à chaud         ║",
				"  ╠══════════════════════════════════════════════════════════╣",
				"  ║  Navigation Telescope (Pendant la recherche)             ║",
				"  ║  Ctrl+j / Ctrl+k   Descendre / Monter                   ║",
				"  ║  Entrée            Ouvrir le fichier sélectionné        ║",
				"  ║  Ctrl+p / Esc      Fermer la recherche                  ║",
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
					{ "<leader>x", desc = "Fermer l'onglet" },
					{ "<leader>q", desc = "Quitter Neovim" },
					{ "<leader>f", group = "Chercher (Telescope)" },
					{ "<leader>r", group = "Rename (LSP)" },
					{ "<leader>c", group = "Code Actions (LSP)" },
					{ "<leader>j", group = "Just / Tâches" },
					{ "<leader>fg", desc = "Live Grep (recherche texte)" },
					{ "<leader>fb", desc = "Chercher dans les Buffers" },
					{ "<leader>fr", desc = "Fichiers récents" },
					{ "<leader>fh", desc = "Aide Neovim (tags)" },
				},
			})
		end,
	},
}
