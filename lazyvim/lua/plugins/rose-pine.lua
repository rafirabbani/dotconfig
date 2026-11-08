-- lua/plugins/rose-pine.lua
return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    local config = {
      variant = "moon",
      dark_variant = "moon",
      styles = {
        transparency = false,
      },
    }
    require("rose-pine").setup(config)
  end,
}
