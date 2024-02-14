return {
    "terrortylor/nvim-comment",
    config = function()
        require("nvim_comment").setup({ create_mappings = false })

        local keyset = require("baron.core.keymap").set
        local cat = "Comment"
        keyset(cat, "i", "<C-k><C-c>", "<C-o>:CommentToggle<CR>", { desc = "Comment/Uncomment" })
        keyset(cat, "n,v", "<C-k><C-c>", ":CommentToggle<CR>", { desc = "Comment/Uncomment" })
    end,
}
