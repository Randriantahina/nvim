vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("nvim.options")
require("nvim.keymaps")
require("nvim.autocmds")
require("nvim.plugins")
require("nvim.tabline")
require("nvim.languages")
