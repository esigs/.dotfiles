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
        root_markers = { '.git' },
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

      vim.lsp.config('pyright', {
        root_markers = { 'pyproject.toml', 'setup.py', '.git' },
      })
      vim.lsp.enable('pyright')
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

  -- REPL (Conjure)
  {
    "Olical/conjure",
    init = function()
      vim.g["conjure#client#python#stdio#command"] = "uv run python3 -iq"
    end,
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Run/Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("dap-python").setup("python3")
      dapui.setup()

      -- Ensure a "Launch file" config exists for Python
      table.insert(dap.configurations.python, 1, {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        console = "integratedTerminal",
      })

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },

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
