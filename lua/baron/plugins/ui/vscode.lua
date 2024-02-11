return {
    "Mofiqul/vscode.nvim",
    lazy = false,
    config = function()
        -- For dark theme (neovim's default)
        vim.o.background = 'dark'
        -- For light theme
        --vim.o.background = 'light'
        local vscode = require("vscode")
        local colors = require("vscode.colors").get_colors()
        vscode.setup({
            transparent = true,
            italic_comments = true,
            disable_nvimtree_bg = true,
            color_overrides = {
                vscLineNumber = '#FFFFFF',
            },
            group_overrides = {
                -- this supports the same val table as vim.api.nvim_set_hl
                -- use colors from this colorscheme by requiring vscode.colors!
                Cursor = { fg = colors.vscDarkBlue, bg = colors.vscLightGreen, bold = true },
            }
        })
        vscode.load()
    end
}
