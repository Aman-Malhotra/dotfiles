local kotlin_language_server = require "mason-lspconfig.server_configurations.kotlin_language_server.init"
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {
        "lua_ls",
        -- add more arguments for adding more language servers
      },
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = {
        "stylua",
        -- add more arguments for adding more null-ls sources
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = {
        "python",
        -- add more arguments for adding more debuggers
      },
    },
  },
  {
    "github/copilot.vim",
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lsp_config = require "lspconfig"
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = {
          kotlin_language_server = {},
        },
        automatic_installation = true,
      }

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.keymap.set("n", "<leader>j", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<leader>dl", vim.diagnostic.setqflist)

      vim.keymap.set({ "n", "i" }, "<C-b>", function() vim.lsp.inlay_hint(0, nil) end)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "F", vim.lsp.buf.format, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        end,
      })

      vim.diagnostic.config {
        virtual_text = true,
        signs = false,
      }

      local dartExcludedFolders = {
        vim.fn.expand "$HOME/AppData/Local/Pub/Cache",
        vim.fn.expand "$HOME/.pub-cache",
        vim.fn.expand "/opt/homebrew/",
        vim.fn.expand "$HOME/fvm/versions/3.24.5/bin/",
      }

      -- lsp_config["dartls"].setup {
      --   capabilities = capabilities,
      --   cmd = {
      --     "dart",
      --     "language-server",
      --     "--protocol=lsp",
      --     -- "--port=8123",
      --     -- "--instrumentation-log-file=/Users/robertbrunhage/Desktop/lsp-log.txt",
      --   },
      --   filetypes = { "dart" },
      --   init_options = {
      --     onlyAnalyzeProjectsWithOpenFiles = false,
      --     suggestFromUnimportedLibraries = true,
      --     closingLabels = true,
      --     outline = false,
      --     flutterOutline = false,
      --   },
      --   settings = {
      --     dart = {
      --       analysisExcludedFolders = dartExcludedFolders,
      --       updateImportsOnRename = true,
      --       completeFunctionCalls = true,
      --       showTodos = true,
      --     },
      --   },
      -- }

      -- Tooltip for the lsp in bottom right
      require("fidget").setup {}

      -- Hot reload :)
      require "dart-tools"
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",

      { "j-hui/fidget.nvim", tag = "legacy" },
      -- support for dart hot reload on save
      "RobertBrunhage/dart-tools.nvim",
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "smolck/command-completion.nvim",
  },
  { -- This plugin
    "Zeioth/makeit.nvim",
    cmd = { "MakeitOpen", "MakeitToggleResults", "MakeitRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},
  },
  { -- The task runner we use
    "stevearc/overseer.nvim",
    commit = "400e762648b70397d0d315e5acaf0ff3597f2d8b",
    cmd = { "MakeitOpen", "MakeitToggleResults", "MakeitRedo" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
    },
  },
}
