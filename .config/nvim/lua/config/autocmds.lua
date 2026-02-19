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

local RemoveComments = function()
  local ts = vim.treesitter
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local lang = ts.language.get_lang(ft) or ft

  local ok, parser = pcall(ts.get_parser, bufnr, lang)
  if not ok then
    return vim.notify("No parser for " .. ft, vim.log.levels.WARN)
  end

  local tree = parser:parse()[1]
  local root = tree:root()
  local query = ts.query.parse(lang, "(comment) @comment")

  local ranges = {}
  for _, node in query:iter_captures(root, bufnr, 0, -1) do
    table.insert(ranges, { node:range() })
  end

  table.sort(ranges, function(a, b)
    if a[1] == b[1] then
      return a[2] < b[2]
    end
    return a[1] > b[1]
  end)

  for _, r in ipairs(ranges) do
    vim.api.nvim_buf_set_text(bufnr, r[1], r[2], r[3], r[4], {})
  end
end

vim.api.nvim_create_user_command("RemoveComments", RemoveComments, {})

if vim.g.neovide == true then
  vim.o.guifont = "RobotoMono Nerd Font:h12"
  vim.g.neovide_fullscreen = true
  vim.api.nvim_set_keymap("n", "<F11>", ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>", {})
end
