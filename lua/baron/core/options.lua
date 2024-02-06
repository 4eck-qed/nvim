-- line numbers
vim.opt.relativenumber = false
vim.opt.number = true

-- tabs & indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- line wrapping
vim.opt.wrap = false

-- search settings
vim.opt.ignorecase = true -- ignore case when searching with lower case
vim.opt.smartcase = true  -- assume case sensitive when searchign w/ upper case

-- cursor line
vim.opt.cursorline = true -- line under cursor

-- appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"

-- backspace
vim.opt.backspace = "indent,eol,start"

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.iskeyword:append("-") -- count `-` as part of a word

vim.opt.updatetime = 100

-- delete trailing ws on save
-- vim.cmd([[autocmd BufWritePre * %s/\s\+$//e]])

vim.cmd([[autocmd BufWritePre * lua notify_async(vim.fn.expand('%:p'), "File saved!", vim.log.levels.INFO, 100)]])
