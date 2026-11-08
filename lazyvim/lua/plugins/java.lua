return {
  "mfussenegger/nvim-jdtls",
  opts = function(_, opts)
    opts.root_dir = function(buf_path)
      local root_dir = vim.fs.root(buf_path, vim.lsp.config.jdtls.root_markers)
      if not root_dir or root_dir == "" then
        vim.notify("Root dir not found", vim.log.levels.ERROR)
        return ""
      end
      if root_dir:match("apps/mepro") then
        local mepro_root_dir = root_dir:match("(.-/apps/mepro)")
        return mepro_root_dir
      end

      if root_dir:match("unified%-pricing") then
        local pricing_service_root_dir = root_dir:match("(.-/unified%-pricing)")
        return pricing_service_root_dir .. "/pricing-service"
      end
      return root_dir
    end
    opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
      java = {
        configuration = {
          runtimes = {
            {
              name = "JavaSE-11",
              path = "/home/parasonge/.sdkman/candidates/java/11.0.15-trava",
            },
            {
              name = "JavaSE-17",
              path = "/home/parasonge/.sdkman/candidates/java/17.0.5-tem",
            },
            {
              name = "JavaSE-21",
              path = "/home/parasonge/.sdkman/candidates/java/21.0.7-tem",
            },
          },
        },
        import = {
          exclusions = {
            "**/node_modules/**",
            "**/.metadata/**",
            "**/src/test/**", -- Add this to ignore all test source code
            "**/build/**",
            "**/bin/**",
            "**/core-log/**",
          },
          gradle = {
            enabled = true,
            wrapper = { enabled = true },
          },
          maven = { enabled = true },
        },
      },
    })
    return opts
  end,
}
