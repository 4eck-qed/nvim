local opt = vim.opt

-- line numbers
opt.relativenumber = false
opt.number = true

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching with lower case
opt.smartcase = true  -- assume case sensitive when searchign w/ upper case

-- cursor line
opt.cursorline = true -- line under cursor

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-") -- count `-` as part of a word

opt.updatetime = 100

-- delete trailing ws on save
-- vim.cmd([[autocmd BufWritePre * %s/\s\+$//e]])

vim.cmd([[autocmd BufWritePre * lua notify_async(vim.fn.expand('%:p'), "File saved!", vim.log.levels.INFO, 100)]])
