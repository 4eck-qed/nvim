return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-native.nvim"
    },

    config = function()
        require('telescope').setup({})

        -- find specific
        vim.keymap.set('n', '<leader>fs', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)

        vim.keymap.set('n', '<leader>ff', ':Telescope find_files')  -- find files in cwd (respects .gitignore)
        vim.keymap.set('n', '<leader>fg', ':Telescope git_files')
        vim.keymap.set('n', '<leader>fs', ':Telescope live_grep')   -- find in cwd as you type
        vim.keymap.set('n', '<leader>fc', ':Telescope grep_string') -- find under cursor in cwd
        -- find under cursor including whitespace
        vim.keymap.set('n', '<leader>fC', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>fb', ':Telescope buffers')   -- list open buffers in cur nvim instance
        vim.keymap.set('n', '<leader>fh', ':Telescope help_tags') -- list available help tags

        -- telescope git cmds
        vim.keymap.set('n', '<leader>gc', ':Telescope git_commits')   -- list all git commits (use <cr> to checkout) [\'gc\' for git commits]
        vim.keymap.set('n', '<leader>gfc', ':Telescope git_bcommits') -- list git commits for current file/buffer (use <cr> to checkout) [\'gfc\' for git file commits]
        vim.keymap.set('n', '<leader>gb', ':Telescope git_branches')  -- list git branches (use <cr> to checkout) [\'gb\' for git branch]
        vim.keymap.set('n', '<leader>gs', ':Telescope git_status')    -- list current changes per file with diff preview [\'gs\' for git status]
    end
}
