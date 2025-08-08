-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- jj pour sortir du mode insertion
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- Insertion des chevrons « et » en mode insertion
vim.keymap.set('i', '<C-q>', '<', { desc = 'Insert left chevron' })
vim.keymap.set('i', '<C-e>', '>', { desc = 'Insert right chevron' })

-- -- Insertion des chevrons « et » en mode normal (insère avant le curseur)
-- vim.api.nvim_set_keymap('n', '<C-g><Left>', 'i«<Esc>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-g><Right>', 'i»<Esc>', { noremap = true, silent = true })

-- --formater
-- vim.keymap.set("n", "<leader>f", function()
--   require("conform").format({ async = true, lsp_fallback = true })
-- end, { desc = "Format file" })

-- --formater
-- vim.keymap.set("n", "<C-s>", function()
--   local ok, conform = pcall(require, "conform")
--   if not ok then
--     vim.notify("Conform.nvim non chargé", vim.log.levels.ERROR)
--     return
--   end
--   -- Formatte avant de sauvegarder
--   conform.format({ bufnr = vim.api.nvim_get_current_buf() })
--   vim.cmd("write")  -- sauvegarde
-- end, { noremap = true, silent = true })

-- vim.keymap.set("i", "<C-s>", function()
--   local ok, conform = pcall(require, "conform")
--   if not ok then
--     vim.notify("Conform.nvim non chargé", vim.log.levels.ERROR)
--     return
--   end
--   conform.format({ bufnr = vim.api.nvim_get_current_buf() })
--   vim.cmd("write")  -- sauvegarde
-- end, { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>n', ':Format<CR>', { noremap = true, silent = true })
