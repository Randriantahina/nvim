local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("i", "jj", "<Esc>", { desc = "Retour au mode normal" })
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quitter Neovim" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Enregistrer" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quitter sans enregistrer" })
map("n", "x", '"_x', opts)
map("n", "<leader>d", '"_d', opts)
map("n", "<leader>c", '"_c', opts)
map("n", "<leader>p", '"_p', opts)
map("n", "dw", 'vb"_d', opts)
map("n", "+", "<C-a>", opts)
map("n", "-", "<C-x>", opts)
map("n", "<C-a>", "gg<S-v>G", opts)
map("n", "te", "<cmd>tabnew<cr>", { desc = "Nouvel onglet" })
map("n", "<Tab>", "<cmd>tabnext<cr>", { desc = "Onglet suivant" })
map("n", "<S-Tab>", "<cmd>tabprevious<cr>", { desc = "Onglet précédent" })
map("n", "ss", "<cmd>split<cr>", { desc = "Division horizontale" })
map("n", "sv", "<cmd>vsplit<cr>", { desc = "Division verticale" })
for key, direction in pairs({ h = "h", j = "j", k = "k", l = "l" }) do
  map("n", "s" .. key, "<C-w>" .. direction, { desc = "Aller à la fenêtre " .. direction })
end
map("n", "<C-m>", "<C-i>", { desc = "Avancer dans la liste des sauts" })
map("n", "<leader>o", "o<Esc>^Da", { desc = "Insérer une ligne dessous" })
map("n", "<leader>O", "O<Esc>^Da", { desc = "Insérer une ligne dessus" })
map("n", "ZR", "<cmd>restart<cr>", { desc = "Redémarrer Neovim" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local buf = event.buf
    local function lmap(lhs, rhs, desc)
      map("n", lhs, rhs, { buffer = buf, desc = desc })
    end
    local function picker_or(method, fallback)
      return function()
        local ok, snacks = pcall(require, "snacks")
        if ok and snacks.picker[method] then snacks.picker[method]() else fallback() end
      end
    end
    lmap("gd", picker_or("lsp_definitions", vim.lsp.buf.definition), "Aller à la définition")
    lmap("gD", picker_or("lsp_declarations", vim.lsp.buf.declaration), "Aller à la déclaration")
    lmap("gy", picker_or("lsp_type_definitions", vim.lsp.buf.type_definition), "Aller à la définition du type")
    lmap("gr", picker_or("lsp_references", vim.lsp.buf.references), "Lister les références")
    lmap("gI", function()
      local client = vim.lsp.get_clients({ bufnr = buf, name = "vtsls" })[1]
      if client then
        vim.lsp.buf.definition()
      else
        vim.lsp.buf.implementation()
      end
    end, "Aller à la définition source / implémentation")
    lmap(";c", picker_or("lsp_incoming_calls", vim.lsp.buf.incoming_calls), "Lister les appels entrants")
    lmap("K", vim.lsp.buf.hover, "Documentation")
    lmap("gK", vim.lsp.buf.signature_help, "Signature")
    map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = buf, desc = "Signature" })
    lmap("<C-j>", function()
      vim.diagnostic.goto_next()
      vim.diagnostic.open_float()
    end, "Diagnostic suivant")
    lmap("<leader>ca", vim.lsp.buf.code_action, "Actions de code")
    lmap("<leader>cr", vim.lsp.buf.rename, "Renommer le symbole")
    lmap("<leader>cR", function()
      local old = vim.api.nvim_buf_get_name(buf)
      vim.ui.input({ prompt = "Nouveau nom : ", default = vim.fn.fnamemodify(old, ":t") }, function(name)
        if not name or name == "" then return end
        local new = vim.fs.joinpath(vim.fn.fnamemodify(old, ":h"), name)
        local params = { files = { { oldUri = vim.uri_from_fname(old), newUri = vim.uri_from_fname(new) } } }
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
          if client:supports_method("workspace/willRenameFiles") then
            local result = client:request_sync("workspace/willRenameFiles", params, 1000, buf)
            if result and result.result and result.result.changes then
              vim.lsp.util.apply_workspace_edit(result.result, client.offset_encoding)
            end
          end
        end
        vim.cmd.write()
        if vim.fn.rename(old, new) == 0 then
          vim.api.nvim_buf_set_name(buf, new)
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
            client:notify("workspace/didRenameFiles", params)
          end
        else
          vim.notify("Impossible de renommer le fichier", vim.log.levels.ERROR)
        end
      end)
    end, "Renommer le fichier")
    lmap("<leader>cl", "<cmd>LspInfo<cr>", "Informations LSP")
    lmap("<leader>f", function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
      "Formater le buffer")
  end,
})

local function copy(text, label)
  vim.fn.setreg("+", text)
  vim.notify("Copié : " .. label)
end

map("n", "<leader>yf", function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  copy(path .. "#L" .. vim.fn.line("."), path)
end, { desc = "Copier le chemin relatif pour un agent" })
map("n", "<leader>yp", function()
  local path = vim.api.nvim_buf_get_name(0)
  copy(path .. "#L" .. vim.fn.line("."), path)
end, { desc = "Copier le chemin absolu pour un agent" })

map("v", "<leader>cc", function()
  local first = vim.fn.line("v")
  local last = vim.fn.line(".")
  if first > last then first, last = last, first end
  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  local ft = vim.bo.filetype
  local short = ({ typescriptreact = "tsx", javascriptreact = "jsx", typescript = "ts", javascript = "js" })[ft] or ft
  local block = table.concat({ "```" .. short .. ' filename="' .. path .. '" line="' .. first .. '"',
    table.concat(lines, "\n"), "```" }, "\n")
  copy(block, path)
end, { desc = "Copier en bloc Markdown avec chemin et lignes" })

map("n", "<leader>j", function()
  local found = vim.fs.find("package.json", { upward = true, path = vim.fn.getcwd(), limit = 1 })[1]
  if not found then vim.notify("Pas de package.json dans ce projet", vim.log.levels.WARN); return end
  local lines = vim.fn.readfile(found)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "json"
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor", width = width, height = height,
    row = math.floor((vim.o.lines - height) / 2), col = math.floor((vim.o.columns - width) / 2),
    style = "minimal", border = "rounded",
  })
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
end, { desc = "Afficher package.json" })

map("n", "<leader>bd", function()
  local current = vim.api.nvim_get_current_buf()
  local visible = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do visible[vim.api.nvim_win_get_buf(win)] = true end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and not visible[buf]
      and not vim.bo[buf].modified and vim.bo[buf].buftype == "" then
      pcall(vim.api.nvim_buf_delete, buf, {})
    end
  end
end, { desc = "Fermer les buffers cachés enregistrés" })
