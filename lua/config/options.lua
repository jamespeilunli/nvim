-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.snacks_animate = false -- disable animations

vim.o.shell = "zsh"

vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20" -- restore previous bash activity

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]]) -- escape goes to normal mode in terminal

-- keymap to copy current filename to clipboard
vim.keymap.set("n", "<leader>b+", ":let @+ = expand('%')<CR>", { noremap = true, silent = true })

-- git diff viewing
vim.api.nvim_create_user_command("Gsd", function()
  vim.cmd("Gitsigns diffthis")
  vim.cmd("wincmd L") -- make the diff left-right instead of up-down
end, {})

-- view long lsp errors
vim.keymap.set("n", "<space>de", vim.diagnostic.open_float, { noremap = true, silent = true })

vim.api.nvim_create_user_command("St", function()
  vim.cmd("belowright 10split")
  vim.cmd("terminal")
  vim.api.nvim_feedkeys("i", "n", false)
end, {})

vim.fn.setreg("l", 'ymu/;\roLOG(INFO) << "pli: " << (pA;`u:delm u\r') -- macro to log in c++

vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
