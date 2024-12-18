-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<S-j>", "<cmd>lua TmuxToggleMaximize()<CR>", { noremap = true, silent = true })

map("n", "<leader>se", "<cmd>ASToggle<CR>", { noremap = true, silent = true, desc = "Toggle Auto Save" })

map("n", "<leader>ts", "<cmd>lua TmuxSplitVertical()<CR>", { noremap = true, silent = true, desc = "Split Vertical" })

map("n", "<C-q>", "<cmd>wqa<CR>", { noremap = true, silent = true, desc = "Save and Quit" })

map("n", "<leader>aa", "<cmd>AerialToggle<CR> ", {
  noremap = true,
  silent = true,
  desc = "Toggle Aerial",
})

map("n", "<leader>ai", "<cmd>lua CheckSupermaven()<CR>", {
  noremap = true,
  silent = true,
  desc = "Check Supermaven",
})

map("n", "<leader>ar", "<cmd>lua RestartSupermaven()<CR>", {
  noremap = true,
  silent = true,
  desc = "Restart Supermaven",
})

map("n", "<leader>ax", "<cmd>lua StopSupermaven()<CR>", {
  noremap = true,
  silent = true,
  desc = "Stop Supermaven",
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
