return {
    "mbbill/undotree",
    config = function()
        local keyset = require("baron.core.keymaps").set
        local plugin = "Undotree"

        keyset(plugin, "n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle" })
    end
}
