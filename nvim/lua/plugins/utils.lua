return {
  -- We can attach our keymaps to any existing plugin spec, or just create a new one.
  -- This is a clean way to add custom keymaps and commands.
  {
    "folke/which-key.nvim", -- This is just a placeholder to attach our keys to.
    keys = {
      {
        "<leader>fsw", -- Mnemonic for "File Save Where"
        function()
          -- This function prompts for a directory, then a filename, then saves.
          -- Check if buffer modifiable
          local isModify = vim.bo.modifiable
          local current_name = vim.fn.bufname("%")
          if not isModify then
            vim.notify("Not modifiable buffer", vim.log.levels.ERROR)
            return
          end

          if current_name ~= "" then
            vim.notify("Not a new buffer,\nPlease rename file using <space>frn", vim.log.levels.ERROR)
            return
          end

          vim.ui.input({
            prompt = "Save to Directory: ",
            completion = "dir", -- This enables directory tab-completion!
            default = vim.fn.getcwd() .. "/", -- Start with the current directory
          }, function(dir_path)
            if not dir_path then
              return
            end

            vim.ui.input({
              prompt = "Filename: ",
            }, function(filename)
              -- If the user cancelled the filename prompt, do nothing.
              if not filename or filename == nil then
                return
              end
              -- Combine the paths and save the file.
              local full_path = dir_path .. "/" .. filename
              vim.cmd("write " .. full_path)
              vim.notify("File saved to: " .. full_path, vim.log.levels.INFO)
            end)
          end)
        end,
        desc = "[F]ile [S]ave to [W][h]ere...",
      },
      {
        "<leader>frn", -- Mnemonic for "File Rename"
        function()
          local isModify = vim.bo.modifiable
          if not isModify then
            vim.notify("Not modifiable buffer", vim.log.levels.ERROR)
            return
          end

          local old_path = vim.fn.expand("%:p")
          if old_path == "" or old_path == nil then
            vim.notify("Buffer has no name, use 'File Save Where' (<leader>fsw) instead.", vim.log.levels.WARN)
            return
          end

          vim.ui.input({
            prompt = "New file path: ",
            default = old_path,
            completion = "file",
          }, function(new_path)
            if not new_path or new_path == "" or new_path == old_path then
              vim.notify("Rename cancelled.", vim.log.levels.INFO)
              return
            end
            -- local _, err = new_path:read(1)
            -- vim.notify("something " .. _, vim.log.levels.INFO)
            -- vim.notify("error " .. err, vim.log.levels.INFO)
            -- if err then
            --   vim.notify("Invalid File Path", vim.log.levels.ERROR)
            --   return
            -- end

            -- Use :saveas to save the buffer to the new location and rename it
            vim.cmd("saveas " .. new_path)

            -- Delete the old file
            vim.fn.delete(old_path)
            vim.notify("Renamed to " .. new_path, vim.log.levels.INFO)
          end)
        end,
        desc = "[F]ile [R]e[n]ame",
      },
    },
  },
}
