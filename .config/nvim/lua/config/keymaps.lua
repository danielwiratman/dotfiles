-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.api.nvim_set_keymap("n", "<S-j>", "<cmd>lua TmuxToggleMaximize()<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap(
  "n",
  "<leader>se",
  "<cmd>ASToggle<CR>",
  { noremap = true, silent = true, desc = "Toggle Auto Save" }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>ts",
  "<cmd>lua TmuxSplitVertical()<CR>",
  { noremap = true, silent = true, desc = "Split Vertical" }
)

vim.api.nvim_set_keymap("n", "<C-q>", "<cmd>wqa<CR>", { noremap = true, silent = true, desc = "Save and Quit" })

vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>AerialToggle<CR> ", {
  noremap = true,
  silent = true,
  desc = "Toggle Aerial",
})
