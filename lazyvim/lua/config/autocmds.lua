-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable vtsls formatting so ESLint can handle it alone
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("disable_vtsls_formatting", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- If the LSP client is vtsls, strip its formatting privileges
    if client and client.name == "vtsls" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*/templates/**/*.tpl", "*.gotmpl", "helmfile*.yaml", "**/helm/**/*.yaml", "*/templates/*.tpl" },
  callback = function()
    vim.opt_local.filetype = "helm"
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-terminal-mappings", { clear = true }),
  callback = function()
    -- Force terminal to start in insert mode instantly
    vim.cmd("startinsert")
    local opts = { buffer = true }
    vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>", opts)
    vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
    vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
    vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
    vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
})
