-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local lazy = require("lazy")
    local update_file = vim.fn.stdpath("data") .. "/lazy-update"

    -- Use the correct function for your Neovim version
    local uv = vim.uv or vim.loop
    local stat = uv.fs_stat(update_file)
    local now = os.time()

    if not stat or (now - stat.mtime.sec) > 86400 then
      vim.schedule(function()
        lazy.update({ show = false })
        vim.fn.writefile({ tostring(now) }, update_file)
        vim.notify("Lazy.nvim: plugins updated automatically ✨", vim.log.levels.INFO)
      end)
    end
  end,
})
