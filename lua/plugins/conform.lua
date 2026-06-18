return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft.java = { "google_java_format" }
    opts.formatters_by_ft.python = { "ruff" }

    opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
      google_java_format = {
        command = "google-java-format",
        args = { "-r", "$FILENAME" },
        stdin = false,
      },
      ruff_format = {
        command = "ruff",
        args = { "format", "$FILENAME" },
        stdin = false,
      },
    })
  end,
}
