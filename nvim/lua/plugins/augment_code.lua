--- Augment Code Plugin Configuration
--- Minimal configuration relying on defaults with Neovim's working directory

return {
  "augmentcode/augment.vim",
  config = function()
    -- Load and setup the modular Augment configuration with defaults

    -- Use Neovim's current working directory
    vim.g.augment_workspace_folders = { vim.fn.getcwd() }

    -- Update working directory when it changes
    -- vim.api.nvim_create_autocmd("DirChanged", {
    --   group = vim.api.nvim_create_augroup("AugmentWorkingDir", { clear = true }),
    --   callback = function()
    --     vim.g.augment_workspace_folders = { vim.fn.getcwd() }
    --   end,
    -- })
  end,
}
