return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- change color for arrows in tree
    vim.cmd([[ highlight NvimTreeFolderArrowClosed guifg=#3FC5FF ]])
    vim.cmd([[ highlight NvimTreeFolderArrowOpen guifg=#3FC5FF ]])

    -- change color and style of executables
    vim.cmd([[ highlight NvimTreeExecFile guifg=#00c400 gui=bold]])

    -- change color and style of files marked for copy
    vim.cmd([[ highlight NvimTreeCopiedHL guifg=#ff00fb gui=italic,underline ]])

    -- change color and style of symlinks
    vim.cmd([[ highlight NvimTreeSymlink guifg=#00eaff gui=italic ]])


    -- configure nvim-tree
    nvimtree.setup({
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

    vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>",
      { desc = "Toggle file explorer on current file" })                                                                    -- toggle file explorer on current file
    vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })                     -- collapse file explorer
    vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })                       -- refresh file explorer
  end,
}
