-- General Options
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local opt = vim.opt
opt.smartindent = true
opt.scrolloff = 8
opt.updatetime = 50
opt.timeoutlen = 300
opt.termguicolors = true
opt.wrap = true
opt.swapfile = false
opt.clipboard = "unnamedplus"
opt.number = true

-- Keymaps
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<Esc>", ":noh<CR>", { silent = true })
vim.keymap.set("n", "p", '"+p', { noremap = true, silent = true })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Setup Plugins
require("lazy").setup("plugins")

require("filetypes")
