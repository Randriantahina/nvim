local servers = {
  "phpactor", "vtsls", "vue_ls", "eslint", "oxlint", "tailwindcss", "cssls", "rust_analyzer", "lua_ls",
}

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.config("phpactor", {
  filetypes = { "php" },
  root_markers = { "composer.json", ".phpactor.yml", ".phpactor.json", ".git" },
})

local vue_ls_path = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
vim.lsp.config("vtsls", {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          { name = "@vue/typescript-plugin", location = vue_ls_path, languages = { "vue" }, configNamespace = "typescript" },
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      inlayHints = {
        variableTypes = { enabled = false },
        parameterTypes = { enabled = false },
        functionLikeReturnTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = false },
      },
    },
  },
})
vim.lsp.config("vue_ls", {
  init_options = { typescript = { tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib" } },
})
vim.lsp.config("rust_analyzer", {
  settings = { ["rust-analyzer"] = { check = { command = "clippy" }, cargo = { allFeatures = true } } },
})
vim.lsp.config("eslint", { settings = { workingDirectory = { mode = "auto" } } })
vim.lsp.enable(servers)

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = { prefix = "●", source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
  float = { border = "rounded", source = "if_many" },
})

-- vim-blade sets the Blade syntax; PHP LSP diagnostics remain on PHP buffers.
vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })
