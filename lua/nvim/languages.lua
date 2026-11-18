-- Neovim 0.12 merges these server definitions with nvim-lspconfig's defaults.
local servers = {
  "phpactor",
  "vtsls",
  "vue_ls",
  "eslint",
  "rust_analyzer",
  "lua_ls",
}

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
          {
            name = "@vue/typescript-plugin",
            location = vue_ls_path,
            languages = { "vue" },
            configNamespace = "typescript",
          },
        },
      },
    },
  },
})
vim.lsp.config("vue_ls", {
  init_options = {
    typescript = { tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib" },
  },
})
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
      cargo = { allFeatures = true },
    },
  },
})
vim.lsp.config("eslint", {
  settings = { workingDirectory = { mode = "auto" } },
})

vim.lsp.enable(servers)

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = { prefix = "●", source = "if_many" },
  signs = true,
  float = { border = "rounded", source = "if_many" },
})

-- Blade files use the dedicated syntax plugin; PHP LSP and phpcs handle PHP files.
vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })
