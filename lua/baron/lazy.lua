local platform = require("baron.core.utils.platform")
local datapath
if platform.is_windows() then
  datapath = os.getenv("LOCALAPPDATA") .. "/nvim-data"
else
  datapath = vim.fn.stdpath("data")
end

local lazypath = datapath .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "baron.plugins" },
  { import = "baron.plugins.core" },
  { import = "baron.plugins.langs" },
  { import = "baron.plugins.lsp" },
  { import = "baron.plugins.toys" },
  { import = "baron.plugins.ui" },
}, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false
  },
})
