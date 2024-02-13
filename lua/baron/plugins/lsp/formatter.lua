return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                lua = { "stylua" },
                python = { "isort", "black" },
                c = { "astyle" },
                cpp = { "astyle" },
                cmake = { "cmake_format" },
                cs = { "astyle" },
                -- ["*"] = { "codespell" },
                ["_"] = { "trim_whitespace" },
            },
            format_on_save = {
                lsp_fallback = false, -- fallback if formatter not available
                async = false,
                timeout_ms = 1000, -- prettier takes long
            },
        })

        local keyset = require("baron.core.keymaps").set
        local format = function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end
        keyset("Formatter", { "n", "v" }, "<leader>kd", format, { desc = "Format file or range" })
        keyset("Formatter", { "i" }, "<C-k><C-d>", format, { desc = "Format file" })
    end,
}
