return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status") -- to configure lazy pending updates count
        local colors = {
            blue = "#65D1FF",
            green = "#3EFFDC",
            violet = "#FF61EF",
            yellow = "#FFDA7B",
            red = "#FF4A4A",
            fg = "#c3ccdc",
            bg = "#112638",
            inactive_bg = "#2c3043",
            black = "#000000",
        }

        local vscode = require("lualine.themes.vscode")
        vscode.insert.a.bg = colors.green
        vscode.visual.a.bg = colors.violet
        vscode.command = {
            a = {
                gui = "bold",
                bg = colors.yellow,
                fg = colors.black,
            },
        }

        -- configure lualine with modified theme
        lualine.setup({
            options = {
                theme = vscode,
            },
            sections = {
                lualine_x = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        color = { fg = "#ff9e64" },
                    },
                    { "encoding" },
                    { "fileformat" },
                    { "filetype" },
                },
            },
        })
    end,
}
