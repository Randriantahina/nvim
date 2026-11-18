local opt = vim.opt

require("config.remote_clipboard").setup()

opt.mouse = ""
opt.clipboard:append("unnamedplus")
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.laststatus = 3
opt.showmatch = true
opt.matchtime = 2
opt.ignorecase = true
opt.smartcase = true
opt.path:append("**")
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*/node_modules/*", "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })
opt.swapfile = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("cache") .. "/undodir"
opt.updatetime = 300
opt.timeoutlen = 500
opt.ttimeoutlen = 0
opt.splitbelow = true
opt.splitright = true
opt.foldlevel = 99
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.smartindent = true
opt.termguicolors = true
opt.pumheight = 10
opt.pumblend = 10
opt.winborder = "rounded"
opt.title = true
opt.fillchars:append({ diff = "╱" })
opt.iskeyword:append("-")

vim.g.autoformat = true
