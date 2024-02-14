return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "antosha417/nvim-lsp-file-operations",
        "echasnovski/mini.base16",
    },
    config = function()
        -- recommended settings from nvim-tree documentation
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- configure nvim-tree
        require("nvim-tree").setup({
            view = {
                width = 35,
                relativenumber = false,
            },
            -- change folder arrow icons
            renderer = {
                indent_markers = {
                    enable = true,
                },
                icons = {
                    glyphs = {
                        folder = {
                            arrow_closed = "»", -- arrow when folder is closed
                            arrow_open = "o", -- arrow when folder is open
                        },
                    },
                },
            },
            -- disable window_picker for explorer to work well with window splits
            actions = {
                open_file = {
                    window_picker = {
                        enable = false,
                    },
                },
            },
            filters = {
                custom = { ".DS_Store" },
            },
            git = {
                ignore = false,
            },
        })

        -- NvimTree
        vim.cmd([[
          " Arrows
          autocmd VimEnter * highlight NvimTreeFolderArrowClosed guifg=#3FC5FF
          autocmd VimEnter * highlight NvimTreeFolderArrowOpen guifg=#3FC5FF

          " Executables
          autocmd VimEnter * highlight NvimTreeExecFile guifg=#00c400 gui=bold

          " Copied
          autocmd VimEnter * highlight NvimTreeCopiedHL guifg=#ff00fb gui=italic

          " Symlinks
          autocmd VimEnter * highlight NvimTreeSymlink guifg=#00eaff gui=italic

          " Git
          autocmd VimEnter * highlight NvimTreeIgnored guifg=#808080 gui=italic
          autocmd VimEnter * highlight NvimTreeFileIgnored guifg=#808080 gui=italic
          autocmd VimEnter * highlight NvimTreeFolderIgnored guifg=#808080 gui=italic
        ]])

        local keyset = require("baron.core.keymap").set
        local cat = "Tree"

        keyset(cat, "n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", {
            desc = "Toggle file explorer",
        })

        keyset(cat, "n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", {
            desc = "Toggle file explorer on current file",
        })

        keyset(cat, "n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", {
            desc = "Collapse file explorer",
        })

        keyset(cat, "n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", {
            desc = "Refresh file explorer",
        })
    end,
}
