local function on_attach(event)
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
end

local servers = {
  clojure_lsp = {
    root_markers = { ".git" },
    settings = {
      ["clojure-lsp"] = {
        -- Disable heavy features that lag on large files.
        ["disabled-features"] = { "semantic-tokens", "document-highlight" },
      },
    },
  },
  pyright = {
    root_markers = { "pyproject.toml", "setup.py", ".git" },
  },
}

return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", { callback = on_attach })
    for name, cfg in pairs(servers) do
      vim.lsp.config(name, cfg)
      vim.lsp.enable(name)
    end
  end,
}
