-- ========================================================================== --
--                        DÉBOGAGE (DAP) : STATION DE CONTROLE                --
-- ========================================================================== --
-- Configuration pour C, C++, Rust (via GDB/cpptools)

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Adaptateur codelldb (installé via Mason)
			local codelldb_root = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension"
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = codelldb_root .. "/adapter/codelldb",
					args = { "--port", "${port}" },
				},
			}

			-- Configuration visuelle (DAP UI)
			dapui.setup()

			-- Virtual Text (Valeurs des variables en bout de ligne)
			require("nvim-dap-virtual-text").setup({
				commented = true, -- Affiche les valeurs sous forme de commentaires
			})

			-- Ouverture automatique de l'interface lors du debug
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Icônes pour les Breakpoints (plus visuel)
			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "🟡", texthl = "DapBreakpoint", linehl = "", numhl = "" }
			)
			vim.fn.sign_define(
				"DapStopped",
				{ text = "▶️", texthl = "DapStopped", linehl = "Visual", numhl = "DapStopped" }
			)

			-- Configurations par défaut pour C, C++, Rust
			local lldb_config = {
				{
					name = "Launch (codelldb)",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					-- Fix Bazzite/Fedora : /var/home est un symlink de /home
					-- Le binaire est compilé avec /home/... mais Neovim ouvre les fichiers via /var/home/...
					initCommands = {
						"settings set target.source-map /home/latty /var/home/latty",
					},
				},
			}

			dap.configurations.cpp = lldb_config
			dap.configurations.c = lldb_config
			dap.configurations.rust = lldb_config

			-- RACCOURCIS CLAVIER (Standard IDE)
			local key = vim.keymap.set
			key("n", "<F5>", dap.continue, { desc = "Debugger: Start/Continue" })
			key("n", "<F10>", dap.step_over, { desc = "Debugger: Step Over" })
			key("n", "<F11>", dap.step_into, { desc = "Debugger: Step Into" })
			key("n", "<F12>", dap.step_out, { desc = "Debugger: Step Out" })
			key("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debugger: Toggle Breakpoint" })
			key("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debugger: Conditional Breakpoint" })

			-- Toggle manuel de l'UI
			key("n", "<leader>du", dapui.toggle, { desc = "Debugger: Toggle UI" })
		end,
	},
}
