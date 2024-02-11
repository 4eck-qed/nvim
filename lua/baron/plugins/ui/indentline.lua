return {
  "Yggdroot/indentLine",
  config = function()
    -- fix hiding of ""
    vim.cmd([[
      autocmd BufEnter * let g:indentLine_setConceal = 1
      autocmd BufEnter *.json,*.md let g:indentLine_setConceal = 0
    ]])
  end
}
