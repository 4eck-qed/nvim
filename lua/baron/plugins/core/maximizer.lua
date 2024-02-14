return {
    "szw/vim-maximizer",
    config = function()
        local keyset = require("baron.core.keymap").set
        keyset("Maximizer", "n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "Maximize/minimize a split" })
    end,
}
