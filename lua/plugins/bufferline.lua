-- ========================================================================== --
--                    PLUGIN : BUFFERLINE (Onglets style VSCode)               --
-- ========================================================================== --
-- Affiche les fichiers ouverts en haut de l'écran.
-- Navigation : Shift+H / Shift+L  (ou Alt+Flèches)

return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers", -- Affichage des buffers ouverts
					style_preset = require("bufferline").style_preset.default,
					themable = true,

					-- Apparence
					separator_style = "thin", -- Séparateurs discrets entre onglets
					show_buffer_close_icons = true,
					show_close_icon = false,
					enforce_regular_tabs = false,
					always_show_bufferline = true,

					-- Groupement de fenêtre (File Tree décalage)
					offsets = {
						{
							filetype = "neo-tree",
							text = "EXPLORATEUR",
							text_align = "left",
							separator = true,
						},
					},

					-- Icônes et indicateurs
					indicator = {
						style = "underline", -- Souligne l'onglet actif
					},
					modified_icon = "●",
					close_icon = " ",
					left_trunc_marker = "",
					right_trunc_marker = "",

					-- Masquer les buffers inutiles (Neo-tree, Quickfix, etc.)
					custom_filter = function(buf_number)
						-- Ne pas afficher les buffers de types spéciaux
						if vim.bo[buf_number].filetype ~= "wiki" then
							return true
						end
						return false
					end,

					-- Navigation souple avec la souris
					mouse_command = "buffer %d", -- Clic gauche : sélectionner
					right_mouse_command = "Bdelete %d", -- Clic droit : fermer proprement
				},
			})

			-- ⌨️ RACCOURCIS CLAVIER (Onglets)
			local key = vim.keymap.set

			-- Navigation rapide (Shift + H/L) — Instinctif sur Neovim
			key("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Onglet précédent" })
			key("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Onglet suivant" })

			-- Navigation style "Alt + Flèches" (Plus proche du feeling VSCode/Windows/KDE)
			key("n", "<A-Left>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Onglet précédent" })
			key("n", "<A-Right>", "<cmd>BufferLineCycleNext<cr>", { desc = "Onglet suivant" })

			-- Déplacer l'onglet courant (Ctrl+Alt + Flèches)
			key("n", "<C-A-Left>", "<cmd>BufferLineMovePrev<cr>", { desc = "Déplacer onglet vers gauche" })
			key("n", "<C-A-Right>", "<cmd>BufferLineMoveNext<cr>", { desc = "Déplacer onglet vers droite" })

			-- Fermer l'onglet courant proprement (Space + x)
			-- Bdelete réduit les risques de fermer nvim accidentellement
			key("n", "<leader>x", "<cmd>Bdelete<cr>", { desc = "Fermer le buffer (onglet)" })
			key("n", "<leader>X", "<cmd>Bdelete!<cr>", { desc = "Fermer le buffer sans sauvegarder" })

			-- Accès direct (Alt + 1-9) — Comme dans VSCode / Chrome
			for i = 1, 9 do
				key("n", string.format("<A-%d>", i), function()
					require("bufferline").go_to(i, true)
				end, { desc = string.format("Aller à l'onglet %d", i) })
			end
		end,
	},
}
