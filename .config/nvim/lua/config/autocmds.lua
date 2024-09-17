-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

function RemoveAllComments()
  vim.api.nvim_command([[
        %s/^\s*\/\/.*$\|^.*\s\+\/\/.*$//g
    ]])
end

vim.cmd("command! RemoveAllComments lua RemoveAllComments()")

function TmuxToggleMaximize()
  vim.fn.system("tmux resizep -Z")
end

function TmuxSplitVertical()
  vim.fn.system("tmux splitw")
end
vim.cmd("command! TmuxSplitVertical lua TmuxSplitVertical()")

function TmuxSplitHorizontal()
  vim.fn.system("tmux splitw -h")
end
vim.cmd("command! TmuxSplitHorizontal lua TmuxSplitHorizontal()")

vim.cmd("command! GoImpl Telescope goimpl")
