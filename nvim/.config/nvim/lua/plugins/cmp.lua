return {
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- LSP completion source
      "hrsh7th/cmp-nvim-lsp",
      -- Buffer completion source
      "hrsh7th/cmp-buffer",
      -- Path completion source
      "hrsh7th/cmp-path",
      -- Snippet engine (required by nvim-cmp)
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          -- Tab to select next item
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          -- Shift-Tab to select previous item
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          -- Enter to confirm
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- Ctrl-Space to trigger completion
          ["<C-Space>"] = cmp.mapping.complete(),
          -- Ctrl-e to abort
          ["<C-e>"] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- LSP completions
          { name = "luasnip" },  -- Snippet completions
          { name = "buffer" },   -- Buffer completions
          { name = "path" },     -- Path completions
        }),
      })
    end,
  },
}
