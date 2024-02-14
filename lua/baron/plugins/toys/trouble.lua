return {
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                icons = false,
            })

            local keyset = require("baron.core.keymap").set
            local cat = "Trouble"

            keyset(cat, "n", "<leader>tt", function()
                require("trouble").toggle()
            end, { desc = "Toggle" })

            keyset(cat, "n", "t[", function()
                require("trouble").previous({ skip_groups = true, jump = true })
            end, { desc = "Previous" })

            keyset(cat, "n", "t]", function()
                require("trouble").next({ skip_groups = true, jump = true })
            end, { desc = "Next" })
        end,
    },
}
