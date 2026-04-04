-- ========================================================================== --
--                        GIT & DIFF : STATION DE CONTRÔLE                    --
-- ========================================================================== --
-- Plugin pour les diffs, l'historique et la résolution de conflits (3-Way Merge)
-- Look & Feel similaire à PyCharm / IntelliJ.

return {
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewFocusFiles" },
		config = function()
			local actions = require("diffview.actions")

			require("diffview").setup({
				enhanced_diff_hl = true, -- Meilleur highlighting des changements
				use_icons = true, -- Utilise les icônes (Nerd Font requise)
				merge_tool = {
					-- Layout à 3 colonnes comme PyCharm
					-- LOCAL (à droite) | OURS/RESULT (au centre) | REMOTE (à gauche)
					layout = "diff3_mixed",
					disable_diagnostics = true, -- Cache les erreurs LSP pendant le merge
				},
				hooks = {
					diff_buf_read = function(bufnr)
						-- Désactive le line wrap pour mieux voir les colonnes
						vim.opt_local.wrap = false
					end,
				},
				keymaps = {
					view = {
						-- Raccourcis faciles dans la vue Diff
						{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Fermer Diffview" } },
						{ "n", "]c", actions.next_conflict, { desc = "Conflit suivant" } },
						{ "n", "[c", actions.prev_conflict, { desc = "Conflit précédent" } },
						
						-- ACTIONS DE RÉSOLUTION (STYLE PYCHARM)
						-- On utilise <leader>g + (l = local, r = remote, b = base, a = all)
						{ "n", "<leader>go", actions.conflict_choose("ours"),   { desc = "Choisir NOTRE version (Ours/Local)" } },
						{ "n", "<leader>gt", actions.conflict_choose("theirs"), { desc = "Choisir LEUR version (Theirs/Remote)" } },
						{ "n", "<leader>gb", actions.conflict_choose("base"),   { desc = "Choisir la BASE commune" } },
						{ "n", "<leader>ga", actions.conflict_choose("all"),    { desc = "Garder TOUT (Fusionne les deux)" } },
					},
					file_panel = {
						{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Fermer Diffview" } },
						{ "n", "s", actions.toggle_stage_entry, { desc = "Stage / Unstage" } },
						{ "n", "<cr>", actions.select_entry, { desc = "Ouvrir le fichier" } },
					},
				},
			})
		end,
	},
}
