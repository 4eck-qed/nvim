return {
    "mbbill/undotree",
    config = function()
        local keyset = require("baron.core.keymap").set
        local cat = "Undotree"

        keyset(cat, "n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle" })
    end,
}
