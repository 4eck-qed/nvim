return {
  "wfxr/minimap.vim",
  config = function()
    vim.g.minimap_width = 10
    vim.g.minimap_auto_start = 0
    vim.g.minimap_auto_start_win_enter = 1
    vim.g.minimap_git_colors = 1
    vim.g.minimap_highlight_range = 1


    vim.cmd([[
          autocmd BufWinEnter * highlight minimapCursor                           ctermbg=59  ctermfg=228 guibg=#131F1B guifg=#297291
          autocmd BufWinEnter * highlight minimapRange                            ctermbg=242 ctermfg=228 guibg=#0E1617 guifg=#547B8C

          autocmd BufWinEnter * highlight minimapDiffLine           cterm=italic  ctermbg=59  ctermfg=228               guifg=#9F00B8
          autocmd BufWinEnter * highlight minimapCursorDiffLine                   ctermbg=59  ctermfg=228 guibg=#131F1B guifg=#DD00FF
          autocmd BufWinEnter * highlight minimapRangeDiffLine                    ctermbg=242 ctermfg=228 guibg=#0E1617 guifg=#9F00B8

          autocmd BufWinEnter * highlight minimapDiffAdded          cterm=italic  ctermbg=59  ctermfg=228               guifg=#36CC00
          autocmd BufWinEnter * highlight minimapCursorDiffAdded                  ctermbg=59  ctermfg=228 guibg=#131F1B guifg=#44FF00
          autocmd BufWinEnter * highlight minimapRangeDiffAdded                   ctermbg=242 ctermfg=228 guibg=#0E1617 guifg=#36CC00

          autocmd BufWinEnter * highlight minimapDiffRemoved        cterm=italic  ctermbg=59  ctermfg=228               guifg=#BA0000
          autocmd BufWinEnter * highlight minimapCursorDiffRemoved                ctermbg=59  ctermfg=228 guibg=#131F1B guifg=#FF0000
          autocmd BufWinEnter * highlight minimapRangeDiffRemoved                 ctermbg=242 ctermfg=228 guibg=#0E1617 guifg=#BA0000
        ]])

    vim.g.minimap_diffadd_color = minimapDiffAdded
    vim.g.minimap_diffremove_color = minimapDiffRemoved
    vim.g.minimap_diff_color = minimapDiffLine

    vim.keymap.set('n', '<leader>mt', ':MinimapToggle<CR>')
  end
}
