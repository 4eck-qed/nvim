return {
    "szw/vim-maximizer",
    config = function()
        local keyset = require("baron.core.keymaps").set
        local plugin = "Maximizer"
        keyset(plugin, "n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "Maximize/minimize a split" })
    end,
}
