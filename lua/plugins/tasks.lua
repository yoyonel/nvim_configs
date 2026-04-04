-- ========================================================================== --
--                  PLUGIN : OVERSEER (Gestionnaire de Tâches)                --
-- ========================================================================== --
-- Permet de lancer et suivre des tâches en arrière-plan (Just, CMake, Make...)
-- Très utile pour automatiser ton workflow avec ton Justfile.

return {
	{
		"stevearc/overseer.nvim",
		dependencies = { "stevearc/dressing.nvim" },
		keys = {
			{ "<leader>jr", function()
				require("overseer").run_template({}, function(task)
					if task then
						require("overseer").run_action(task, "open hsplit")
						-- 🏹 AUTO-CLOSE MANUEL SUR SUCCESS
						task:subscribe("on_complete", function(result)
							if result.status == "SUCCESS" then
								vim.defer_fn(function()
									local bufnr = task:get_bufnr()
									if bufnr then
										local wins = vim.fn.win_findbuf(bufnr)
										for _, win in ipairs(wins) do
											pcall(vim.api.nvim_win_close, win, true)
										end
									end
								end, 1500) -- Ferme après 1.5s de succès
							end
						end)
						vim.defer_fn(function() vim.cmd("normal! G") end, 50)
					end
				end)
			end, desc = "Just : Recettes" },
			{ "<leader>jo", "<cmd>OverseerToggle right<cr>", desc = "Just : Gestion des tâches" },
			{ "<leader>jl", "<cmd>OverseerRunLast<cr>", desc = "Just : Relancer dernière tâche" },
		},
		config = function()
			require("overseer").setup({
				templates = { "builtin" }, 
			})
		end,
	},
}
