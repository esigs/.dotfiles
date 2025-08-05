return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/lazydev.nvim",
			ft = { "clojure",
				"edn",
				"lua",
				"nix",
				"sh",
			},
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		config = function()
			local lspconfig = require("lspconfig")

			local function on_attach(_, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- Diagnostics
				map("n", "<leader>Q", vim.diagnostic.setqflist, "Diagnostics to quickfix")
				map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostics (float)")
				map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics to loclist")
				map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
				map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

				-- LSP
				map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
				map("n", "<leader>f", function() vim.lsp.buf.format() end, "Format buffer")
				map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
				map("n", "K", vim.lsp.buf.hover, "Hover info")
				map("n", "gd", vim.lsp.buf.definition, "Go to definition")
				map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local function setup_lsp(name, opts)
				opts = opts or {}
				opts.on_attach = opts.on_attach or on_attach
				opts.capabilities = opts.capabilities or capabilities
				lspconfig[name].setup(opts)
			end

			setup_lsp("bashls")
			setup_lsp("clojure_lsp", {
				handlers = {
					["textDocument/publishDiagnostics"] = function() end
				}
			})
			setup_lsp("lua_ls")
			setup_lsp("nixd")
		end,
	}
}
