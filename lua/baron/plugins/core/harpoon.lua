return {
    "ThePrimeagen/harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        local keyset = require("baron.core.keymap").set
        local cat = "Harpoon"
        keyset(cat, "n", "<leader>ha", mark.add_file, { desc = "Add file" })
        keyset(cat, "n", "<C-Space>", ui.toggle_quick_menu, { desc = "Toggle menu" })
        keyset(cat, "n", "<C-1>", function()
            ui.nav_file(1)
        end, { desc = "Navigate to file 1" })
        keyset(cat, "n", "<C-2>", function()
            ui.nav_file(2)
        end, { desc = "Navigate to file 2" })
        keyset(cat, "n", "<C-3>", function()
            ui.nav_file(3)
        end, { desc = "Navigate to file 3" })
        keyset(cat, "n", "<C-4>", function()
            ui.nav_file(4)
        end, { desc = "Navigate to file 4" })
    end,
}
