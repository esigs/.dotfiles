return {
  -- Colorscheme (Stylix base16)
  {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local palette_path = vim.fn.expand("~/.config/stylix/palette.json")
      if vim.fn.filereadable(palette_path) == 1 then
        local f = io.open(palette_path, "r")
        local json = f:read("*all")
        f:close()
        local palette = vim.fn.json_decode(json)
        require("base16-colorscheme").setup({
          base00 = "#" .. palette.base00,
          base01 = "#" .. palette.base01,
          base02 = "#" .. palette.base02,
          base03 = "#" .. palette.base03,
          base04 = "#" .. palette.base04,
          base05 = "#" .. palette.base05,
          base06 = "#" .. palette.base06,
          base07 = "#" .. palette.base07,
          base08 = "#" .. palette.base08,
          base09 = "#" .. palette.base09,
          base0A = "#" .. palette.base0A,
          base0B = "#" .. palette.base0B,
          base0C = "#" .. palette.base0C,
          base0D = "#" .. palette.base0D,
          base0E = "#" .. palette.base0E,
          base0F = "#" .. palette.base0F,
        })
      end
    end,
  },

  -- Core/UI
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
      { "<leader>ps", function() require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") }) end, desc = "Search String" },
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "clojure", "c_sharp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Helper for keybindings
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          map("gd", vim.lsp.buf.definition, "Definition")
          map("gr", vim.lsp.buf.references, "References")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Action")
          map("<leader>f", vim.lsp.buf.format, "Format")
          map("<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
          map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
          map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
          map("<leader>sd", require("telescope.builtin").diagnostics, "Search Diagnostics")
        end,
      })

      -- Servers
      vim.lsp.config('clojure_lsp', {
        settings = {
          ["clojure-lsp"] = {
            -- Keep lightweight: disable heavy/slow features only
            ["disabled-features"] = {
              "semantic-tokens",    -- can cause lag on large files
              "document-highlight", -- highlighting all refs under cursor
            },
          },
        },
      })
      vim.lsp.enable('clojure_lsp')
    end,
  },
  
  -- C# / Roslyn
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {
      broad_search = true,
      config = {
        -- Pass common settings or capabilities here if needed
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
        },
      },
    },
  },

  -- Clojure Specifics
  { "Olical/conjure" },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        completion = { autocomplete = false }, -- only show on <C-Space>
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
