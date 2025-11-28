return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                fieldalignment = false,
              },
              buildFlags = { "-tags=dev,prod" },
            },
          },
        },
        ruby_lsp = {
          cmd = { "bundle", "exec", "ruby-lsp" },
        },
        dartls = {
          cmd = { "dart", "language-server", "--protocol=lsp" },
        },
      },
      inlay_hints = {
        enabled = false,
      },
    },
  },
  {
    "stevearc/aerial.nvim",
    opts = {
      layout = {
        max_width = 0.3,
        min_width = 0.3,
        resize_to_content = false,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {},
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
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
  {
    "mistweaverco/kulala.nvim",
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {},
      },
    },
  },
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      set({ "n", "x" }, "<leader>n", function()
        mc.matchAddCursor(1)
      end)
      set({ "n", "x" }, "<leader>N", function()
        mc.matchAddCursor(-1)
      end)
      set("n", "<m-leftmouse>", mc.handleMouse)
      set("n", "<m-leftdrag>", mc.handleMouseDrag)
      set("n", "<m-leftrelease>", mc.handleMouseRelease)

      mc.addKeymapLayer(function(layerSet)
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "emmet-language-server", "tailwindcss-language-server" } },
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      {
        "<leader>th",
        function()
          require("toggleterm").toggle(0, 10, vim.loop.cwd(), "horizontal")
        end,
        desc = "Term horizontal",
      },
      {
        "<leader>tv",
        function()
          require("toggleterm").toggle(0, 0, vim.loop.cwd(), "vertical")
        end,
        desc = "Term vertical",
      },
      {
        "<leader>tf",
        function()
          require("toggleterm").toggle(0, 0, vim.loop.cwd(), "float")
        end,
        desc = "Term float",
      },
    },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "horizontal",
    },
  },

  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        ignore_filetypes = { cpp = true }, -- or { "cpp", }
        color = {
          suggestion_color = "#ffffff",
          cterm = 244,
        },
        log_level = "info", -- set to "off" to disable logging completely
        disable_inline_completion = false, -- disables inline completion for use with cmp
        disable_keymaps = false, -- disables built in keymaps for more manual control
        condition = function()
          return false
        end,
      })
    end,
  },
}
