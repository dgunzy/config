return {
  -- Configure LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Your servers from mason-lspconfig setup
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
                disable = { "empty-line" },
              },
              format = {
                enable = true,
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
        gopls = {},
        yamlls = {},
        bashls = {},
      },
    },
  },

  -- Configure Mason with your preferred tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "lua-language-server",
        "pyright",
        "gopls",
        "yaml-language-server",
        "bash-language-server",

        -- Formatters and linters from your none-ls config
        -- "stylua",
        -- "prettier",
        -- "shfmt",
        -- "ruff",
        -- "golangci-lint",
        -- "gofmt",
        -- "isort",
      },
    },
  },

  -- Configure formatting
  {
    "stevearc/conform.nvim", -- LazyVim uses conform.nvim for formatting
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "ruff_format" },
        go = { "gofmt" },
        sh = { "shfmt" },
        ["javascript"] = { "prettier" },
        ["typescript"] = { "prettier" },
        ["html"] = { "prettier" },
        ["json"] = { "prettier" },
        ["yaml"] = { "prettier" },
        ["markdown"] = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
}
