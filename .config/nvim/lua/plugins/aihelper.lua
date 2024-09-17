return {
  {
    "supermaven-inc/supermaven-nvim",
    opts = {
      keymaps = {
        accept_suggestion = "<C-g>",
        clear_suggestion = "<C-x>",
        accept_word = "<C-;>",
      },
      condition = function()
        return false
      end,
    },
  },
}
