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
-- Auto-reload files changed outside of nvim.
opt.autoread = true

-- Per-buffer libuv fs_event watcher so changes reload instantly without focus.
local watchers = {}

local function stop_watcher(bufnr)
  local w = watchers[bufnr]
  if w then
    w:stop()
    w:close()
    watchers[bufnr] = nil
  end
end

local function start_watcher(bufnr)
  -- Tear down any prior watcher for this buffer before attaching a fresh one.
  stop_watcher(bufnr)
  -- Skip invalid buffers (could have been wiped between schedule and run).
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  -- Skip special buffers like help, terminal, quickfix — only watch real files.
  if vim.bo[bufnr].buftype ~= "" then return end
  -- Resolve the on-disk path; bail if unnamed or not yet readable.
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" or vim.fn.filereadable(path) == 0 then return end

  -- Allocate a libuv fs_event handle and remember it so we can stop it later.
  local w = vim.uv.new_fs_event()
  if not w then return end
  watchers[bufnr] = w
  -- Begin watching; the callback runs on libuv's thread, so schedule onto main.
  w:start(path, {}, vim.schedule_wrap(function(err)
    if err then return end
    -- Run :checktime in the watched buffer's context so the right file reloads.
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_call(bufnr, function() vim.cmd("checktime") end)
    end
    -- Many editors save via write-and-rename, which detaches the watcher; re-arm.
    start_watcher(bufnr)
  end))
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufFilePost" }, {
  callback = function(args) start_watcher(args.buf) end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  callback = function(args) stop_watcher(args.buf) end,
})

-- Surface a notification when a reload happens so it's visible.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})

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

-- Capture Nix treesitter paths before lazy.nvim resets rtp
local nix_rtp = {}
for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
  if path:match("treesitter%-grammar%-") then
    table.insert(nix_rtp, path)
  end
end

-- Setup Plugins
require("lazy").setup("plugins", {
  performance = {
    rtp = {
      paths = nix_rtp,
    },
  },
})

require("filetypes")
