return {
  "terrortylor/nvim-comment",
  config = function()
    require("nvim_comment").setup({ create_mappings = false })

    local keyset = require("baron.core.keymaps").set
    local plugin = "Comment"
    keyset(plugin, "i", "<C-k><C-c>", "<C-o>:CommentToggle<CR>", { desc = "Comment/Uncomment" })
    keyset(plugin, "n,v", "<C-k><C-c>", ":CommentToggle<CR>", { desc = "Comment/Uncomment" })
  end,
}
