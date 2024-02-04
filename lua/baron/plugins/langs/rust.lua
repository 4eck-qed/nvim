return {
    "rust-lang/rust.vim",
    config = function()
        -- require("rust").setup({
        --     ft = "rust",
        -- }) -- cant find it for some reason
        vim.g.rustfmt_autosave = 1
    end
}
