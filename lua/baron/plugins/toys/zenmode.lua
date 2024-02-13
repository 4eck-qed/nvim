return {
    "folke/zen-mode.nvim",
    config = function()
        local keyset = require("baron.core.keymaps").set
        local plugin = "ZenMode"

        keyset(plugin, "n", "<leader>zz", function()
            require("zen-mode").setup({
                window = {
                    width = 100,
                    options = {},
                },
            })
            require("zen-mode").toggle()
            vim.wo.wrap = false
            vim.wo.number = true
            vim.wo.rnu = false
        end, { desc = "Zen mode" })

        keyset(plugin, "n", "<leader>zZ", function()
            require("zen-mode").setup({
                window = {
                    width = 100,
                    options = {},
                },
            })
            require("zen-mode").toggle()
            vim.wo.wrap = false
            vim.wo.number = false
            vim.wo.rnu = false
            vim.opt.colorcolumn = "0"
        end, { desc = "Zen mode without line nums" })
    end,
}
