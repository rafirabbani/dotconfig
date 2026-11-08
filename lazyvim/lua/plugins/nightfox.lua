-- Default options
return {
  "EdenEast/nightfox.nvim",
  config = function()
    require("nightfox").setup({
      options = {
        transparent = false,
      },
    })
  end,
}
