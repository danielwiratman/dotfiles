return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/my-vault/**.md",
      "BufReadPre " .. "/mnt/c/Users/Daniel/Documents/Daniel's Notes/**.md",
      "BufReadPre " .. "/mnt/c/Users/Daniel/Daniel's Notes/**.md",
      "BufReadPre " .. "/mnt/c/Users/equnix/Documents/Daniel's Notes/**.md",
      "BufReadPre " .. "/mnt/c/Users/equnix/Daniel's Notes/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/my-vault",
          overrides = {
            notes_subdir = "03 Extracted",
          },
        },
      },
      mappings = {
        ["<C-l>"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
        ["<leader>od"] = {
          action = function()
            vim.cmd("ObsidianToday")
          end,
          opts = { buffer = true, desc = "Obsidian Today" },
        },
        ["<leader>ok"] = {
          action = function()
            vim.cmd("e My\\ Kanban.md")
          end,
          opts = { buffer = true, desc = "My Kanban" },
        },
      },
      daily_notes = {
        folder = "01 Daily Notes",
      },
      note_id_func = function(title)
        return os.date("%Y-%m-%d") .. "_" .. title
      end,
      disable_frontmatter = true,
    },
  },
}
