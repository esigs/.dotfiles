local map = vim.keymap.set

map("n", "<leader>pv", vim.cmd.Ex)
map("n", "<Esc>", ":noh<CR>", { silent = true })
map("n", "p", '"+p', { noremap = true, silent = true })
map("n", "<leader>R", require("resize"), { desc = "Resize windows" })
