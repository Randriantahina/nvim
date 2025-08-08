return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local Util = require("lazyvim.util")
      local mason_registry = require("mason-registry")

      local function lsp_keymaps(_, bufnr)
        local map = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        -- Gestion sécurisée de telescope.builtin
        local ok, telescope_builtin = pcall(require, "telescope.builtin")

        map("grn", vim.lsp.buf.rename, "[R]ename")
        map("gra", vim.lsp.buf.code_action, "Code [A]ction")
        map("grd", vim.lsp.buf.definition, "[G]oto [D]efinition")

        if ok and telescope_builtin then
          map("grr", telescope_builtin.lsp_references, "[G]oto [R]eferences")
          map("gri", telescope_builtin.lsp_implementation, "[G]oto [I]mplementation")
          map("grt", telescope_builtin.lsp_type_definitions, "Type [D]efinition")
          map("gds", telescope_builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
          map("gws", telescope_builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        else
          -- Si Telescope non dispo, fallback vers les fonctions LSP classiques
          map("grr", vim.lsp.buf.references, "[G]oto [R]eferences")
          map("gri", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
          map("grt", vim.lsp.buf.type_definition, "Type [D]efinition")
          -- Pour symbols, tu peux mettre un message ou rien
        end

        vim.keymap.set("i", "<c-h>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
      end

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              hint = { enable = true },
            },
          },
        },
        ["ts_ls"] = {},
        tailwindcss = {},
        intelephense = {},
        eslint = {
          settings = {
            workingDirectory = { mode = "auto" },
          },
        },
      }

      require("mason").setup()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "prettierd",
          "pint",
          "eslint_d",
          "intelephense",
        },
      })
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local server_opts = servers[server_name] or {}
            server_opts.on_attach = lsp_keymaps
            server_opts.capabilities = vim.lsp.protocol.make_client_capabilities()
            require("lspconfig")[server_name].setup(server_opts)
          end,
        },
      })

      -- AJOUT POUR AFFICHER LES DIAGNOSTICS FLOTTANTS COMME VSCODE

      -- Icônes personnalisées style VS Code
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      vim.diagnostic.config({
        virtual_text = {
          prefix = "●", -- ou ""
          spacing = 2,
          source = "if_many",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          focusable = false,
          header = "",
          prefix = "",
        },
      })

      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { focus = false })
        end,
      })
    end,
  },

{
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      tsx = { "prettierd" },           -- ✅ Next.js (TSX)
      vue = { "prettierd" },           -- ✅ si tu touches au Vue
      html = { "prettierd" },
      css = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      php = { "php_cs_fixer" },
      php = { "php_cs_fixer" },              -- ✅ Laravel Blade templates
    },
    format_on_save = function(bufnr)
      local ignore_filetypes = { "sql" }
      return {
        timeout_ms = 500,
        lsp_fallback = not vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype),
      }
    end,
  },
},

}
