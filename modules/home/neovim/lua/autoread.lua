local watchers = {}

local function stop(bufnr)
  local w = watchers[bufnr]
  if w then
    w:stop()
    w:close()
    watchers[bufnr] = nil
  end
end

local function start(bufnr)
  stop(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  if vim.bo[bufnr].buftype ~= "" then return end
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" or vim.fn.filereadable(path) == 0 then return end

  local w = vim.uv.new_fs_event()
  if not w then return end
  watchers[bufnr] = w
  w:start(path, {}, vim.schedule_wrap(function(err)
    if err then return end
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_call(bufnr, function() vim.cmd("checktime") end)
    end
    -- Re-arm: write-and-rename saves detach the inotify handle.
    start(bufnr)
  end))
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufFilePost" }, {
  callback = function(args) start(args.buf) end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  callback = function(args) stop(args.buf) end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})
