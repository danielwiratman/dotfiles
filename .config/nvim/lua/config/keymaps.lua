-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<S-j>", "<cmd>lua TmuxToggleMaximize()<CR>", { noremap = true, silent = true })

map("n", "<leader>ts", "<cmd>lua TmuxSplitVertical()<CR>", { noremap = true, silent = true, desc = "Split Vertical" })

map("n", "<leader>aa", "<cmd>AerialToggle<CR> ", {
  noremap = true,
  silent = true,
  desc = "Toggle Aerial",
})

map("n", "<leader>Rr", "<cmd>lua require('kulala').run()<CR>", {
  noremap = true,
  silent = true,
  desc = "Execute API Call",
})

map("n", "<leader>Rh", "<cmd>lua require('kulala').toggle_view()<CR>", {
  noremap = true,
  silent = true,
  desc = "Toggles body and header view",
})

map("n", "<leader>Rq", "<cmd>lua require('kulala').close()<CR>", {
  noremap = true,
  silent = true,
  desc = "Close the current Kulala buffer",
})
