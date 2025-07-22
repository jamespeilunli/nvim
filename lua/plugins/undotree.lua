return {
  "mbbill/undotree",
  init = function()
    vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
  end,
  config = function()
    -- set up persistent undo directory, etc.
    if vim.fn.has("persistent_undo") == 1 then
      local dir = vim.fn.stdpath("state") .. "/undo"
      vim.fn.mkdir(dir, "p")
      vim.o.undodir = dir
      vim.o.undofile = true
    end
  end,
}
