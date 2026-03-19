-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard:append("unnamedplus")
vim.opt.cursorline = false
vim.opt.modeline = false
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#e4e022", bg = "NONE" })
