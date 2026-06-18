return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          enabled = false,
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(server)
        return server ~= "vtsls"
      end, opts.ensure_installed or {})
    end,
  },
}
