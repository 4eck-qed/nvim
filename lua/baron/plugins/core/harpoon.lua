return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    vim.keymap.set("n", "<leader>ha", mark.add_file)
    vim.keymap.set("n", "<C-Space>", ui.toggle_quick_menu)

    vim.keymap.set("n", "<C-1>", function() ui.nav_file(1) end)
    vim.keymap.set("n", "<C-2>", function() ui.nav_file(2) end)
    vim.keymap.set("n", "<C-3>", function() ui.nav_file(3) end)
    vim.keymap.set("n", "<C-4>", function() ui.nav_file(4) end)
  end,
}
