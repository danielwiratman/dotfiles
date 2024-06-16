return {
  {
    "f-person/git-blame.nvim",
    config = function()
      local git_blame = require("gitblame")
      git_blame.setup({
        enabled = true,
      })

      vim.g.gitblame_display_virtual_text = 0

      require("lualine").setup({
        sections = {
          lualine_c = {
            { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
          },
        },
      })
    end,
  },
}
