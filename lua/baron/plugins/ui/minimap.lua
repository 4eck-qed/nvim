return {
    "wfxr/minimap.vim",
    lazy = false,
    config = function()
        vim.g.minimap_width = 10
        vim.g.minimap_auto_start = 0
        vim.g.minimap_auto_start_win_enter = 1
        vim.g.minimap_git_colors = 1
        vim.g.minimap_highlight_range = 1

        vim.cmd([[
      autocmd VimEnter * highlight minimapCursor                           ctermbg=59  ctermfg=228 guibg=#131F1B guifg=#297291
      autocmd VimEnter * highlight minimapRange                            ctermbg=242 ctermfg=228 guibg=#0E1617 guifg=#547B8C

      autocmd VimEnter * highlight minimapDiffLine           cterm=italic  ctermbg=59  ctermfg=228               guifg=#9F00B8
      autocmd VimEnter * highlight minimapCursorDiffLine                   ctermbg=59  ctermfg=228 guibg=#131F1B guifg=#DD00FF
      autocmd VimEnter * highlight minimapRangeDiffLine                    ctermbg=242 ctermfg=228 guibg=#0E1617 guifg=#9F00B8

      autocmd VimEnter * highlight minimapDiffAdded          cterm=italic  ctermbg=59  ctermfg=228               guifg=#36CC00
      autocmd VimEnter * highlight minimapCursorDiffAdded                  ctermbg=59  ctermfg=228 guibg=#131F1B guifg=#44FF00
      autocmd VimEnter * highlight minimapRangeDiffAdded                   ctermbg=242 ctermfg=228 guibg=#0E1617 guifg=#36CC00

      autocmd VimEnter * highlight minimapDiffRemoved        cterm=italic  ctermbg=59  ctermfg=228               guifg=#BA0000
      autocmd VimEnter * highlight minimapCursorDiffRemoved                ctermbg=59  ctermfg=228 guibg=#131F1B guifg=#FF0000
      autocmd VimEnter * highlight minimapRangeDiffRemoved                 ctermbg=242 ctermfg=228 guibg=#0E1617 guifg=#BA0000
    ]])

        local keyset = require("baron.core.keymap").set
        local cat = "Minimap"
        keyset(cat, "n", "<leader>mt", ":MinimapToggle<CR>", { desc = "Toggle" })
    end,
}
