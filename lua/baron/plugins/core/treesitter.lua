return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
        -- "nvim-treesitter/nvim-treesitter-textobjects",
        "windwp/nvim-ts-autotag",
    },
    -- event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            -- A list of parser names, or "all"
            ensure_installed = {
                "bash",
                "c",
                "cmake",
                "cpp",
                "c_sharp",
                "css",
                "dockerfile",
                "doxygen",
                "gitignore",
                "graphql",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "lua",
                -- "luadoc",
                "markdown",
                "markdown_inline",
                "proto",
                "python",
                "rust",
                "scss",
                "svelte",
                "sxhkdrc",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
                "yuck",
                "zig",
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = false,

            -- context_commentstring = {
            --     enable = true,
            --     commentary_integration = {
            --         -- change default mapping
            --         Commentary = 'g/',
            --         -- disable default mapping
            --         CommentaryLine = false,
            --     },
            -- },

            indent = { enable = true },

            -- enable autotagging (w/ nvim-ts-autotag plugin)
            --autotag = { enable = true },

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = { "markdown" },
            },
        })

        local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        treesitter_parser_config.templ = {
            install_info = {
                url = "https://github.com/vrischmann/tree-sitter-templ.git",
                files = { "src/parser.c", "src/scanner.c" },
                branch = "master",
            },
        }

        vim.treesitter.language.register("templ", "templ")

        require('ts_context_commentstring').setup()
        vim.g.skip_ts_context_commentstring_module = true
    end,
}
