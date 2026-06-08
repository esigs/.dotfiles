require("options")
require("keymaps")
require("autoread")
require("filetypes")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Capture Nix-provided treesitter grammar paths before lazy.nvim prunes rtp.
local nix_rtp = {}
for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
  if path:match("treesitter%-grammar%-") then
    table.insert(nix_rtp, path)
  end
end

require("lazy").setup("plugins", {
  performance = { rtp = { paths = nix_rtp } },
})
