-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<S-j>", "<cmd>lua TmuxToggleMaximize()<CR>", { noremap = true, silent = true })

map("n", "<leader>se", "<cmd>ASToggle<CR>", { noremap = true, silent = true, desc = "Toggle Auto Save" })

map("n", "<leader>ts", "<cmd>lua TmuxSplitVertical()<CR>", { noremap = true, silent = true, desc = "Split Vertical" })

map("n", "<C-q>", "<cmd>wqa<CR>", { noremap = true, silent = true, desc = "Save and Quit" })

map("n", "<leader>a", "<cmd>AerialToggle<CR> ", {
  noremap = true,
  silent = true,
  desc = "Toggle Aerial",
})

map("n", "<leader>AI", "<cmd>SupermavenToggle<CR>", {
  noremap = true,
  silent = true,
  desc = "Toggle Supermaven",
})
