return {
  {
    "ibhagwan/fzf-lua",
    opts = {
      winopts = {
        height = 0.85,
        width = 1,
      },
    },
    -- Your custom keymaps to launch FZF remain here
    keys = {
      {
        "<leader>Gb",
        function()
          require("fzf-lua").git_branches({
            actions = {
              ["default"] = function(selected)
                local branch = selected[1]
                if branch then
                  branch = branch:gsub("%* ", ""):gsub("remotes/origin/", "")
                  vim.notify("branch: " .. branch, vim.log.levels.INFO)
                  vim.cmd("!git switch -c " .. branch)
                end
              end,
            },
          })
        end,
        desc = "Find & Checkout Git Branch (FZF)",
      },
    },
  },
}
