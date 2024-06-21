return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        cssls = {},
        emmet_ls = {},
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
        dartls = {},
        prismals = {},
        eslint = {
          codeActionOnSave = true,
        },
      },
      inlay_hints = {
        enabled = false,
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "shfmt",
        "stylua",

        "html-lsp",
        "css-lsp",
        "emmet-language-server",

        "gofumpt",
        "goimports",
        "impl",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "markdown", "dart", "prisma" },
    },
  },

  {
    "https://github.com/aklt/plantuml-syntax",
  },

  {
    "tree-sitter-grammars/tree-sitter-markdown",
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters.sqlfluff = {
        args = { "format", "--dialect=postgres", "-" },
      }
    end,
  },
}
