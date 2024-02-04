return {
  "terrortylor/nvim-comment",
  config = function()
    require("nvim_comment").setup({ create_mappings = false })

    vim.keymap.set('i', "<C-k><C-c>", '<C-o>:CommentToggle<CR>')
    vim.keymap.set('n', "<C-k><C-c>", ':CommentToggle<CR>')
    vim.keymap.set('v', "<C-k><C-c>", ':CommentToggle<CR>')
  end,
}
