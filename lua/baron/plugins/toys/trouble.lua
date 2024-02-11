return {
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                icons = false,
            })

            local keyset = require("baron.core.keymaps").set
            local plugin = "Trouble"

            keyset(plugin, "n", "<leader>tt", function()
                require("trouble").toggle()
            end, { desc = "Toggle" })

            keyset(plugin, "n", "[", function()
                require("trouble").previous({ skip_groups = true, jump = true });
            end, { desc = "Previous" })

            keyset(plugin, "n", "]", function()
                require("trouble").next({ skip_groups = true, jump = true });
            end, { desc = "Next" })
        end
    },
}
