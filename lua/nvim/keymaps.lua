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
    lmap("gd", vim.lsp.buf.definition, "Aller à la définition")
    lmap("gD", vim.lsp.buf.declaration, "Aller à la déclaration")
    lmap("gy", vim.lsp.buf.type_definition, "Aller à la définition du type")
    lmap("gr", vim.lsp.buf.references, "Lister les références")
    lmap("K", vim.lsp.buf.hover, "Documentation")
    lmap("<leader>ca", vim.lsp.buf.code_action, "Actions de code")
    lmap("<leader>cr", vim.lsp.buf.rename, "Renommer le symbole")
    lmap("<leader>cl", "<cmd>LspInfo<cr>", "Informations LSP")
    lmap("<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Formater le buffer")
  end,
})
