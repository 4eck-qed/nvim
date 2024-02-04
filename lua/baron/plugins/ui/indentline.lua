return {
    "Yggdroot/indentLine",
    config = function()
        vim.cmd([[
          " let g:indentLine_setConceal = 0
          " let g:indentLine_setColors = 0
          " let g:indentLine_color_term = 239
          " let g:indentLine_char = '┆'
          " let g:indentLine_concealcursor = 'inc'
          " let g:indentLine_conceallevel = 2
        ]])

        -- fix hiding of ""
        vim.cmd([[autocmd BufEnter * let g:indentLine_setConceal = 1]])
        vim.cmd([[autocmd BufEnter *.json,*.md let g:indentLine_setConceal = 0]])
    end
}
