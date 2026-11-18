local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function() vim.highlight.on_yank({ timeout = 180 }) end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "json", "jsonc", "markdown" },
  callback = function() vim.wo.conceallevel = 0 end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args)
    vim.wo[0].cursorline = vim.api.nvim_get_current_buf() == args.buf
  end,
})
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  group = group,
  callback = function() vim.wo.cursorline = true end,
})
vim.api.nvim_create_autocmd("WinLeave", {
  group = group,
  callback = function() vim.wo.cursorline = false end,
})
