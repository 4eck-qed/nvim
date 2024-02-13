return {
    "danymat/neogen",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "L3MON4D3/LuaSnip",
    },
    config = function()
        local neogen = require("neogen")

        neogen.setup({
            snippet_engine = "luasnip",
        })

        local keyset = require("baron.core.keymaps").set
        local plugin = "Neogen"

        keyset(plugin, "n", "<leader>nf", function()
            neogen.generate({ type = "func" })
        end, {
            desc = "Generate for function",
        })

        keyset(plugin, "n", "<leader>nt", function()
            neogen.generate({ type = "type" })
        end, {
            desc = "Generate for type",
        })
    end,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
}
