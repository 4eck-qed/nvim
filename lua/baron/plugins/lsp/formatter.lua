return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        c = { "astyle" },
        cpp = { "astyle" },
        cmake = { "cmake_format" },
        cs = { "astyle" },
        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = {
        lsp_fallback = true, -- fallback if formatter not available
        async = false,
        timeout_ms = 500,
      },
    })

    local keyset = require("baron.core.keymaps").set
    keyset("Formatter", { "n", "v" }, "<leader>kd", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      })
    end, { desc = "Format file or range" })
  end
}
