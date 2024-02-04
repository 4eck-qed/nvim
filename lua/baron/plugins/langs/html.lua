return {
    "mattn/emmet-vim",
    dependencies = {
        "sheerun/vim-polyglot", -- still dont know what this is
        "windwp/nvim-ts-autotag", -- auto close & rename tags
    },
    config = function()
        require('nvim-ts-autotag').setup()
    end
}
