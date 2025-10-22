return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Mason for other LSPs (not C# - that's managed by Nix)
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Setup mason for other LSPs (we manage C# LSP via Nix)
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_installation = false,
      })

      -- LSP keybindings - only active when LSP is attached
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Navigation
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "Go to references")
          map("gI", vim.lsp.buf.implementation, "Go to implementation")

          -- Documentation
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help")

          -- Refactoring
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")

          -- Formatting
          map("<leader>f", vim.lsp.buf.format, "Format file")
        end,
      })

      -- Global diagnostic keybindings (not buffer-specific)
      vim.keymap.set("n", "<leader>xx", "<cmd>Telescope diagnostics<cr>", { desc = "Show all diagnostics" })
      vim.keymap.set("n", "<leader>xb", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Show buffer diagnostics" })
      vim.keymap.set("n", "<leader>xq", vim.diagnostic.setqflist, { desc = "Send diagnostics to quickfix" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]e", function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = "Next error" })
      vim.keymap.set("n", "[e", function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = "Previous error" })
    end,
  },

  -- Roslyn LSP plugin for C#
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {
      -- Leave empty for default settings
      -- The plugin will handle downloading and configuring Roslyn
      config = {
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
        },
      },
    },
  },
}
