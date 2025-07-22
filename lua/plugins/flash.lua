return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = { modes = { char = {
    highlight = { backdrop = false },
  } } },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, false },
    { "S", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  },
}
