local plugins = {
  "https://github.com/folke/snacks.nvim",
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/saghen/blink.cmp",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/echasnovski/mini.pairs",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/brenoprata10/nvim-highlight-colors",
  "https://github.com/jwalton512/vim-blade",
}

local function load_omarchy_theme()
  local theme_file = vim.fn.stdpath("config") .. "/lua/plugins/theme.lua"
  if vim.fn.filereadable(theme_file) ~= 1 then
    return
  end
  local ok, specs = pcall(dofile, theme_file)
  if not ok or type(specs) ~= "table" then
    return
  end

  local plugin_spec, colorscheme
  for _, spec in ipairs(specs) do
    if type(spec) == "table" and type(spec[1]) == "string" then
      if spec[1] == "LazyVim/LazyVim" then
        colorscheme = spec.opts and spec.opts.colorscheme
      elseif not plugin_spec then
        plugin_spec = spec
      end
    end
  end
  if not plugin_spec then
    return
  end

  local source = plugin_spec[1]
  if not source:match("^%w+://") then
    source = "https://github.com/" .. source
  end
  local name = plugin_spec.name or source:match("([^/]+)$"):gsub("%.nvim$", "")
  vim.pack.add({ { src = source, name = name, version = plugin_spec.branch } })

  local module = name
  if module == "neovim" then
    module = colorscheme and colorscheme:gsub("%-.*$", "") or module
  end
  local setup_ok, theme = pcall(require, module)
  if setup_ok and type(theme.setup) == "function" and plugin_spec.opts then
    pcall(theme.setup, plugin_spec.opts)
  end

  if colorscheme then
    local scheme_ok = pcall(vim.cmd.colorscheme, colorscheme)
    if not scheme_ok then
      vim.schedule(function()
        pcall(vim.cmd.colorscheme, colorscheme)
      end)
    end
  end
  local transparency = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"
  if vim.fn.filereadable(transparency) == 1 then
    pcall(dofile, transparency)
  end
end

vim.pack.add(plugins)
load_omarchy_theme()

local function setup(name, fn)
  local ok, module = pcall(require, name)
  if ok then
    pcall(fn, module)
  end
end

setup("mini.icons", function(mini) mini.setup() end)
setup("mini.pairs", function(mini) mini.setup() end)
setup("oil", function(oil)
  oil.setup({ view_options = { show_hidden = true } })
  vim.keymap.set("n", "sf", function() oil.open_float() end, { desc = "Parcourir les fichiers" })
end)
setup("snacks", function(snacks)
  snacks.setup({
    picker = { enabled = true },
    notifier = { enabled = true },
    indent = { enabled = true },
    words = { enabled = true },
    scroll = { enabled = false },
  })
  vim.keymap.set("n", ";f", function() snacks.picker.files({ hidden = true }) end, { desc = "Chercher un fichier" })
  vim.keymap.set("n", ";r", function() snacks.picker.grep({ hidden = true }) end, { desc = "Chercher du texte" })
  vim.keymap.set("n", ";;", function() snacks.picker.resume() end, { desc = "Reprendre la recherche" })
  vim.keymap.set("n", "\\\\", function() snacks.picker.buffers() end, { desc = "Buffers ouverts" })
  vim.keymap.set("n", ";e", function() snacks.picker.diagnostics() end, { desc = "Diagnostics" })
  vim.keymap.set("n", ";n", function() snacks.picker.notifications() end, { desc = "Notifications" })
  vim.keymap.set("n", ";h", function() snacks.picker.git_diff() end, { desc = "Changements Git" })
end)
setup("gitsigns", function(gitsigns) gitsigns.setup() end)
setup("lualine", function(lualine)
  lualine.setup({ options = { globalstatus = true, theme = "auto" } })
end)
setup("todo-comments", function(todo) todo.setup() end)
setup("nvim-highlight-colors", function(colors) colors.setup({ render = "background" }) end)
setup("mason", function(mason) mason.setup() end)
setup("mason-tool-installer", function(installer)
  installer.setup({
    ensure_installed = {
      "phpactor", "vtsls", "vue-language-server", "rust-analyzer", "eslint-lsp", "oxlint",
      "phpcs", "prettierd", "prettier", "stylua", "shfmt", "lua-language-server",
    },
    auto_update = false,
    run_on_start = true,
  })
end)

local treesitter_parsers = {
  "bash", "c", "css", "diff", "html", "javascript", "json", "lua", "markdown", "php",
  "python", "rust", "scss", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
}
setup("nvim-treesitter", function(ts)
  ts.install(treesitter_parsers)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = treesitter_parsers,
    callback = function(args) pcall(vim.treesitter.start, args.buf) end,
  })
end)

setup("blink.cmp", function(blink)
  blink.setup({ keymap = { preset = "enter" }, completion = { documentation = { auto_show = true } } })
end)

setup("conform", function(conform)
  conform.setup({
    format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
    formatters = {
      pint = {
        command = "vendor/bin/pint",
        args = { "$FILENAME" },
        stdin = false,
        cwd = require("conform.util").root_file({ "artisan", "composer.json" }),
        require_cwd = true,
        condition = function(_, ctx)
          return ctx.root ~= nil and vim.fn.executable(ctx.root .. "/vendor/bin/pint") == 1
        end,
      },
    },
    formatters_by_ft = {
      php = { "pint" },
      javascript = { "oxfmt", "prettierd", "prettier" },
      javascriptreact = { "oxfmt", "prettierd", "prettier" },
      typescript = { "oxfmt", "prettierd", "prettier" },
      typescriptreact = { "oxfmt", "prettierd", "prettier" },
      vue = { "oxfmt", "prettierd", "prettier" },
      json = { "oxfmt", "prettierd", "prettier" },
      css = { "oxfmt", "prettierd", "prettier" },
      scss = { "oxfmt", "prettierd", "prettier" },
      html = { "oxfmt", "prettierd", "prettier" },
      yaml = { "oxfmt", "prettierd", "prettier" },
      markdown = { "oxfmt", "prettierd", "prettier" },
      lua = { "stylua" },
      sh = { "shfmt" },
      rust = { "rustfmt" },
    },
  })
  vim.api.nvim_create_user_command("ToggleFormatter", function()
    vim.g.autoformat = not vim.g.autoformat
    vim.notify("Formatage automatique " .. (vim.g.autoformat and "activé" or "désactivé"))
  end, { desc = "Activer ou désactiver le formatage automatique" })
  vim.keymap.set("n", "<leader>f", function() conform.format({ async = true, lsp_format = "fallback" }) end,
    { desc = "Formater le buffer" })
end)

setup("lint", function(lint)
  lint.linters_by_ft = {
    php = { "php", "phpcs" },
    javascript = { "eslint" },
    javascriptreact = { "eslint" },
    typescript = { "eslint" },
    typescriptreact = { "eslint" },
    vue = { "eslint" },
    rust = { "clippy" },
  }
  local group = vim.api.nvim_create_augroup("NvimLint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = group,
    callback = function() lint.try_lint() end,
  })
end)

vim.keymap.set("n", "<leader>gb", function() require("gitsigns").blame_line({ full = true }) end,
  { desc = "Blâme cette ligne" })
vim.keymap.set("n", "<leader>gB", function() require("gitsigns").blame() end, { desc = "Blâme du fichier" })
