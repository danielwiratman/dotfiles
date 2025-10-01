-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

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

-- Normal mode mappings
vim.keymap.del("n", "<leader>fT")
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<c-/>")
vim.keymap.del("n", "<c-_>")

-- Terminal mode mappings
vim.keymap.del("t", "<c-/>")
vim.keymap.del("t", "<c-_>")

map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
