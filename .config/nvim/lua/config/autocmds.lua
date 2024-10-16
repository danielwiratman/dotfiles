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

function CheckSupermaven()
  local api = require("supermaven-nvim.api")
  if api.is_running() then
    print("Supermaven is running")
  else
    print("Supermaven is not running")
  end
end

function RestartSupermaven()
  local api = require("supermaven-nvim.api")
  api.restart()
  if api.is_running() then
    print("Supermaven restart successful")
  else
    print("Supermaven restart failed")
  end
end

function StopSupermaven()
  local api = require("supermaven-nvim.api")
  api.stop()
  if not api.is_running() then
    print("Supermaven stop successful")
  else
    print("Supermaven stop failed")
  end
end

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("cpp", {
  s("ustd", {
    t("using namespace std;"),
  }),
})
