return {
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",

        dependencies = { "rafamadriz/friendly-snippets" },

        config = function()
            local ls = require("luasnip")
            ls.filetype_extend("javascript", { "jsdoc" })

            local keyset = require("baron.core.keymaps").set
            local plugin = "LuaSnip"
            keyset(plugin, { "i" }, "<C-e>", function()
                ls.expand()
            end, { silent = true, desc = "Expand" })
            keyset(plugin, { "i", "s" }, "<C-[>", function()
                ls.jump(1)
            end, { silent = true, desc = "Next" })
            keyset(plugin, { "i", "s" }, "<C-]>", function()
                ls.jump(-1)
            end, { silent = true, desc = "Previous" })
            keyset(plugin, { "i", "s" }, "<C-E>", function()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end, { silent = true, desc = "Change choice" })
        end,
    },
}
