return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-native.nvim"
    },

    config = function()
        require('telescope').setup({})
        local builtin = require("telescope.builtin")

        local keyset = require("baron.core.keymaps").set
        local plugin = "Telescope"

        keyset(plugin, 'n', '<leader>fs', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = "Find specific" })

        keyset(plugin, 'n', '<leader>ff', ':Telescope find_files<CR>', {
            desc = "Find files in cwd (respects .gitignore)"
        })
        keyset(plugin, 'n', '<leader>fg', ':Telescope git_files<CR>', {
            desc = "Find git files"
        })
        keyset(plugin, 'n', '<leader>fw', ':Telescope live_grep<CR>', { desc = "Find in cwd as you type" })
        keyset(plugin, 'n', '<leader>fc', ':Telescope grep_string<CR>', { desc = "Find under cursor in cwd" })
        keyset(plugin, 'n', '<leader>fC', function() builtin.grep_string({ search = vim.fn.expand("<cWORD>") }) end, {
            desc = "Find under cursor including whitespace"
        })
        keyset(plugin, 'n', '<leader>fb', ':Telescope buffers<CR>', { desc = "List open buffers in cur nvim instance" })
        keyset(plugin, 'n', '<leader>fh', ':Telescope help_tags<CR>', { desc = "List available help tags" })

        -- telescope git cmds
        keyset(plugin, 'n', '<leader>gc', ':Telescope git_commits<CR>', { desc = "List all git commits" })
        keyset(plugin, 'n', '<leader>gfc', ':Telescope git_bcommits<CR>', {
            desc = "List git commits for current file/buffer"
        })
        keyset(plugin, 'n', '<leader>gb', ':Telescope git_branches<CR>', { desc = "List git branches" })
        keyset(plugin, 'n', '<leader>gs', ':Telescope git_status<CR>', {
            desc = "List current changes per file with diff preview"
        })
    end
}
