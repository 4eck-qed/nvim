return {
    "dense-analysis/ale",
    config = function()
        -- vim.cmd([[
        --     " Fix files with prettier, and then ESLint.
        --     let b:ale_fixers = ['eslint']
        --     " Equivalent to the above.
        --     let b:ale_fixers = {'javascript': ['eslint']}
        --     " Set this variable to 1 to fix files when you save them.
        --     let g:ale_fix_on_save = 1
        -- ]])
    end
}
