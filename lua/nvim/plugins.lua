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
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/brenoprata10/nvim-highlight-colors",
  "https://github.com/b0o/incline.nvim",
  "https://github.com/rachartier/tiny-cmdline.nvim",
  { src = "https://github.com/craftzdog/mini.diff", version = "feat/grouping", name = "mini.diff" },
  "https://github.com/esmuellert/codediff.nvim",
  "https://github.com/linrongbin16/gitlinker.nvim",
  "https://github.com/jwalton512/vim-blade",
  "https://github.com/yetone/avante.nvim",
}

vim.pack.add(plugins)

local function setup(name, fn)
  local ok, module = pcall(require, name)
  if ok then fn(module) end
end

-- Read Omarchy's active colorscheme spec without loading LazyVim itself.
local function load_omarchy_theme()
  local theme_file = vim.fn.stdpath("config") .. "/lua/plugins/theme.lua"
  if vim.fn.filereadable(theme_file) ~= 1 then return end
  local ok, specs = pcall(dofile, theme_file)
  if not ok or type(specs) ~= "table" then return end

  local plugin_spec, colorscheme
  for _, spec in ipairs(specs) do
    if type(spec) == "table" and type(spec[1]) == "string" then
      if spec.opts and spec.opts.colorscheme then
        colorscheme = spec.opts.colorscheme
      elseif not plugin_spec then
        plugin_spec = spec
      end
    end
  end
  if not plugin_spec then return end

  local source = plugin_spec[1]
  if not source:match("^%w+://") then source = "https://github.com/" .. source end
  local name = plugin_spec.name or source:match("([^/]+)$"):gsub("%.nvim$", "")
  vim.pack.add({ { src = source, name = name, version = plugin_spec.branch } })

  local ok_theme, theme = pcall(require, name)
  if ok_theme and type(theme.setup) == "function" and plugin_spec.opts then
    theme.setup(plugin_spec.opts)
  end
  if colorscheme then pcall(vim.cmd.colorscheme, colorscheme) end

  local transparency = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"
  if vim.fn.filereadable(transparency) == 1 then pcall(dofile, transparency) end
end
load_omarchy_theme()

setup("mini.icons", function(mini)
  mini.setup()
  mini.mock_nvim_web_devicons()
end)
setup("mini.pairs", function(mini) mini.setup() end)
setup("oil", function(oil)
  oil.setup({ view_options = { show_hidden = true } })
  vim.keymap.set("n", "sf", function() oil.open_float() end, { desc = "Ouvrir le navigateur de fichiers" })
end)
setup("snacks", function(snacks)
  snacks.setup({
    picker = { enabled = true }, notifier = { enabled = true }, indent = { enabled = true },
    statuscolumn = { enabled = true }, words = { enabled = true }, scroll = { enabled = false },
    lazygit = { enabled = true },
  })
  local map = vim.keymap.set
  map("n", ";f", function() snacks.picker.files({ hidden = true }) end, { desc = "Fichiers" })
  map("n", ";r", function() snacks.picker.grep({ hidden = true }) end, { desc = "Recherche texte" })
  map("n", ";;", function() snacks.picker.resume() end, { desc = "Recherche précédente" })
  map("n", "\\\\", function() snacks.picker.buffers() end, { desc = "Buffers" })
  map("n", ";e", function() snacks.picker.diagnostics() end, { desc = "Diagnostics" })
  map("n", ";n", function() snacks.picker.notifications() end, { desc = "Notifications" })
  map("n", ";h", function() snacks.picker.git_diff() end, { desc = "Diff Git" })
  map("n", ";g", function() snacks.lazygit() end, { desc = "Ouvrir Lazygit" })
end)
setup("gitsigns", function(gitsigns)
  gitsigns.setup()
  local map = vim.keymap.set
  map("n", "<leader>gb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blâme de la ligne" })
  map("n", "<leader>gB", function() gitsigns.blame() end, { desc = "Blâme du fichier" })
  map("n", "<leader>gs", gitsigns.stage_buffer, { desc = "Indexer le fichier" })
  map("n", "<leader>gh", gitsigns.stage_hunk, { desc = "Indexer le hunk" })
end)
setup("lualine", function(lualine)
  local function project_root()
    local file = vim.api.nvim_buf_get_name(0)
    local markers = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }
    local start = file ~= "" and vim.fn.fnamemodify(file, ":h") or vim.fn.getcwd()
    local found = vim.fs.find(markers, { upward = true, path = start })[1]
    if not found then return "" end
    local root = vim.fs.dirname(found)
    if root == vim.fn.getcwd() then return "" end
    return vim.fn.fnamemodify(root, ":t")
  end
  lualine.setup({
    options = { globalstatus = true, theme = "auto" },
    sections = {
      lualine_a = { "mode", function()
        local reg = vim.fn.reg_recording()
        return reg ~= "" and ("REC @" .. reg) or ""
      end },
      lualine_b = { "branch" },
      lualine_c = { project_root, { "filename", path = 1 }, "filetype" },
      lualine_x = { "macro", "diagnostics", "diff" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end)
setup("incline", function(incline)
  local devicons = require("nvim-web-devicons")
  incline.setup({
    window = { margin = { vertical = 0, horizontal = 1 } },
    hide = { cursorline = true },
    render = function(props)
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
      if filename == "" then filename = "[No Name]" end
      if vim.bo[props.buf].modified then filename = "[+] " .. filename end
      local icon, color = devicons.get_icon_color(filename)
      return { { icon or "", guifg = color }, { " " }, { filename } }
    end,
  })
end)
setup("todo-comments", function(todo) todo.setup() end)
setup("nvim-highlight-colors", function(colors) colors.setup({ render = "background", enable_tailwind = false }) end)
setup("tiny-cmdline", function(cmdline)
  cmdline.setup({
    width = { value = "60%", min = 40, max = 80 },
    position = { x = "50%", y = "20%" },
    on_reposition = cmdline.adapters.blink,
  })
end)
setup("mason", function(mason) mason.setup() end)
setup("mason-tool-installer", function(installer)
  installer.setup({
    ensure_installed = {
      "lua-language-server", "vtsls", "eslint-lsp", "oxlint", "tailwindcss-language-server", "css-lsp",
      "rust-analyzer", "phpactor", "vue-language-server", "phpcs", "prettier", "prettierd", "oxfmt",
      "stylua", "shfmt",
    },
    auto_update = false,
    run_on_start = true,
  })
end)

local parsers = {
  "astro", "bash", "c", "cmake", "cpp", "css", "diff", "fish", "gitignore", "go", "graphql", "html",
  "http", "java", "javascript", "jsdoc", "json", "lua", "luadoc", "luap", "markdown", "markdown_inline",
  "php", "printf", "python", "query", "regex", "rust", "scss", "sql", "svelte", "toml", "tsx",
  "typescript", "vim", "vimdoc", "xml", "yaml", "vue",
}
setup("nvim-treesitter", function(ts)
  ts.install(parsers)
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(event)
      local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
      if lang then pcall(vim.treesitter.start, event.buf, lang) end
    end,
  })
end)

setup("blink.cmp", function(blink)
  blink.setup({
    keymap = { preset = "enter" },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      ghost_text = { enabled = false },
    },
    cmdline = { completion = { menu = { auto_show = function(ctx) return vim.fn.getcmdtype() == ":" end } } },
  })
end)

setup("conform", function(conform)
  conform.setup({
    format_on_save = function(bufnr)
      if not vim.g.autoformat then return end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
    formatters = {
      oxfmt = { condition = function(_, ctx)
        return ctx.root and (vim.fn.filereadable(ctx.root .. "/.oxfmtrc.json") == 1
          or vim.fn.filereadable(ctx.root .. "/.oxfmtrc.jsonc") == 1
          or vim.fn.filereadable(ctx.root .. "/oxfmt.config.ts") == 1
          or vim.fn.filereadable(ctx.root .. "/vite.config.ts") == 1)
      end },
      pint = {
        command = "vendor/bin/pint", args = { "$FILENAME" }, stdin = false,
        cwd = require("conform.util").root_file({ "artisan", "composer.json" }), require_cwd = true,
        condition = function(_, ctx)
          return ctx.root ~= nil and vim.fn.executable(ctx.root .. "/vendor/bin/pint") == 1
        end,
      },
    },
    formatters_by_ft = {
      javascript = { "oxfmt", "prettierd", "prettier" }, javascriptreact = { "oxfmt", "prettierd", "prettier" },
      typescript = { "oxfmt", "prettierd", "prettier" }, typescriptreact = { "oxfmt", "prettierd", "prettier" },
      vue = { "oxfmt", "prettierd", "prettier" }, json = { "oxfmt", "prettierd", "prettier" },
      css = { "oxfmt", "prettierd", "prettier" }, scss = { "oxfmt", "prettierd", "prettier" },
      less = { "oxfmt", "prettierd", "prettier" }, html = { "oxfmt", "prettierd", "prettier" },
      markdown = { "oxfmt", "prettierd", "prettier" }, mdx = { "oxfmt", "prettierd", "prettier" },
      yaml = { "oxfmt", "prettierd", "prettier" }, lua = { "stylua" }, sh = { "shfmt" },
      fish = { "fish_indent" }, php = { "pint" }, rust = { "rustfmt" },
    },
  })
  vim.api.nvim_create_user_command("ToggleFormatter", function()
    vim.g.autoformat = not vim.g.autoformat
    vim.notify("Formatage automatique " .. (vim.g.autoformat and "activé" or "désactivé"))
  end, { desc = "Basculer le formatage à l'enregistrement" })
  vim.keymap.set("n", "<leader>f", function() conform.format({ async = true, lsp_format = "fallback" }) end,
    { desc = "Formater le buffer" })
end)

setup("lint", function(lint)
  lint.linters_by_ft = {
    php = { "php", "phpcs" },
  }
  local group = vim.api.nvim_create_augroup("NvimLint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = group, callback = function() lint.try_lint() end,
  })
end)

setup("mini.diff", function(diff)
  diff.setup({})
  vim.keymap.set("n", "<leader>gd", function() MiniDiff.toggle_overlay() end, { desc = "Basculer l'overlay diff" })
end)
setup("codediff", function()
  vim.keymap.set("n", "<leader>dv", "<cmd>CodeDiff<cr>", { desc = "Vue diff" })
  vim.keymap.set("n", "<leader>dh", "<cmd>CodeDiff history<cr>", { desc = "Historique du fichier" })
  vim.keymap.set("n", "<leader>dH", "<cmd>CodeDiff history:all<cr>", { desc = "Historique du dépôt" })
end)
setup("gitlinker", function(gitlinker)
  gitlinker.setup()
  vim.keymap.set({ "n", "v" }, "<leader>gy", "<cmd>GitLink<cr>", { desc = "Copier le lien Git" })
end)
setup("avante", function(avante)
  vim.g.avante = {
    provider = "claude-code",
    mode = "agentic",
    auto_suggestions_provider = nil,
    selector = { provider = "snacks" },
    input = { provider = "snacks" },
    behaviour = {
      auto_suggestions = false,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      auto_approve_tool_permissions = false,
      acp_follow_agent_locations = true,
    },
    acp_providers = {
      ["claude-code"] = {
        command = "npx",
        args = { "--yes", "@zed-industries/claude-agent-acp" },
        env = {
          NODE_NO_WARNINGS = "1",
          PATH = os.getenv("PATH"),
          HOME = os.getenv("HOME"),
          ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
          ACP_PERMISSION_MODE = "default",
        },
      },
    },
  }
  avante.setup()
end)
