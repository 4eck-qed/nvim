local utils = require("baron.core.utils")
local lazypath
if utils.is_windows() then
  lazypath = os.getenv("LOCALAPPDATA") .. "/nvim-data" .. "/lazy/lazy.nvim"
else
  lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
end

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
