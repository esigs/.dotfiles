-- usability
vim.opt.smartindent = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.termguicolors = true
vim.opt.wrap = true
vim.opt.swapfile = false

-- leaders
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- pop back to the dir
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--- why would we ever have more than one clipboard? 
vim.opt.clipboard = "unnamedplus"
vim.api.nvim_set_keymap("n", "p", '"+p', { noremap = true, silent = true })

-- line numbers, we're not animals
vim.wo.number = true

-- Clear search highlight when pressing Escape
vim.api.nvim_set_keymap("n", "<Esc>", ":noh<CR>", { noremap = true, silent = true })

require("default.lazy")
