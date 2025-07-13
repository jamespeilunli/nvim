-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.snacks_animate = false -- disable animations

vim.o.shell = "zsh"

vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20" -- restore previous bash activity

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]]) -- escape goes to normal mode in terminal

-- keymaps to copy current filename to clipboard
vim.keymap.set("n", "<leader>b+", ":let @+ = expand('%:p')<CR>", { noremap = true, silent = true }) -- absolute path
vim.keymap.set("n", "<leader>b=", function()
  vim.fn.setreg("+", vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":."))
end, { noremap = true, silent = true }) -- relative path

-- git diff viewing
vim.api.nvim_create_user_command("Gsd", function()
  vim.cmd("Gitsigns diffthis")
  vim.cmd("wincmd L") -- make the diff left-right instead of up-down
end, {})

-- view long lsp errors
vim.keymap.set("n", "<space>de", vim.diagnostic.open_float, { noremap = true, silent = true })

-- copy lsp errors: https://www.reddit.com/r/neovim/comments/15xszia/comment/k2p2zzh/
vim.keymap.set(
  "n",
  "<leader>dc",
  [[:lua YankDiagnosticError()<CR>]],
  { noremap = true, silent = true, desc = "Copy error" }
)

function YankDiagnosticError()
  vim.diagnostic.open_float()
  vim.diagnostic.open_float()
  local win_id = vim.fn.win_getid() -- get the window ID of the floating window
  vim.cmd("normal! j") -- move down one row
  vim.cmd("normal! VG") -- select everything from that row down
  vim.cmd("normal! y") -- yank selected text
  vim.api.nvim_win_close(win_id, true) -- close the floating window by its ID
end

vim.api.nvim_create_user_command("St", function()
  vim.cmd("belowright 10split")

  --[[ open in current directory
  local file_dir = vim.fn.expand("%:h")
  local git_root = vim.fn.systemlist("cd " .. file_dir .. " && git rev-parse --show-toplevel")[1]
  if vim.v.shell_error == 0 and git_root ~= "" then
    vim.cmd("enew")
    vim.fn.termopen("cd " .. git_root .. " && zsh")
  else
    vim.cmd("terminal")
  end
  ]]

  vim.cmd("terminal")
  vim.api.nvim_feedkeys("i", "n", false)
end, {})

vim.fn.setreg("l", 'ymu/;\roSystem.out.printf("pli: %s%n", pA;`u:delm u\r') -- macro to log in java

vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
