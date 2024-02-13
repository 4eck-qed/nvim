return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    config = function()
        -- Keymaps
        local keyset = require("baron.core.keymaps").set
        local plugin = "LSP"
        keyset(plugin, "n", "<leader>rr", vim.lsp.buf.rename, { desc = "Rename" })
        keyset(plugin, "n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
        keyset(plugin, "n", "<F12>", vim.lsp.buf.definition, { desc = "Goto definition" })
        keyset(plugin, "n", "<F36>", vim.lsp.buf.implementation, { desc = "Goto implementation" })
        keyset(plugin, "n", "<leader>fr", require("telescope.builtin").lsp_references, { desc = "Find references" })
        keyset(plugin, "n", "K", vim.lsp.buf.hover, { desc = "Hover" })
        keyset(plugin, "n", "<leader>[", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", {
            silent = true,
            desc = "Goto previous diagnostic",
        })
        keyset(plugin, "n", "<leader>]", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", {
            silent = true,
            desc = "Goto next diagnostic",
        })

        -- Lsp config
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities()
        )
        require("fidget").setup({})
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })
        require("mason-lspconfig").setup({
            ensure_installed = {
                "clangd",
                "cmake",
                -- "csharp_ls",
                -- "omnisharp_mono",
                "omnisharp",
                "cssls",
                "eslint",
                "html",
                "lua_ls",
                "ltex", -- LaTeX
                "marksman", -- Markdown
                "powershell_es",
                "pyright", -- Python
                "rust_analyzer",
                "tsserver",
                "tailwindcss",
                "taplo", -- Toml
                "svelte",
                "zls", -- Zig
            },
            automatic_installation = true,
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                },
                            },
                        },
                    })
                end,
            },
        })

        -- Diagnostics
        local signs = { Error = "", Warn = "", Hint = "💡", Info = "🔥" }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
        vim.diagnostic.config({
            -- update_in_insert = true,
            -- virtual_lines = true,
            virtual_text = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
        -- vim.diagnostic.config({
        --     virtual_text = {
        --         prefix = "●",
        --     },
        --
        --     update_in_insert = false,
        --     float = {
        --         source = "always", --Or 'if_many'
        --     },
        -- })

        -- -- Disable virtual text for diagnostics
        -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        --     virtual_text = false,
        -- })

        -- Autocomplete/snippets
        local cmp = require("cmp")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<S-TAB>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<TAB>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- For luasnip users.
            }, {
                { name = "buffer" },
            }),
        })
    end,
}
