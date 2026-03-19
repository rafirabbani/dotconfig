return {
  "stevearc/conform.nvim",
  keys = {
    {
      "<leader>ucf",
      function()
        vim.g.disable_prettier_formatting = not vim.g.disable_prettier_formatting
        local state = vim.g.disable_prettier_formatting and "Disabled" or "Enabled"
        local level = vim.g.disable_prettier_formatting and vim.log.levels.WARN or vim.log.levels.INFO
        vim.notify("Global Prettier " .. state, level, { title = "Formatting" })
      end,
      desc = "Toggle Prettier Formatter (Global)",
    },
    {
      "<leader>ucF",
      function()
        vim.b.disable_prettier_formatting = not vim.b.disable_prettier_formatting
        local state = vim.b.disable_prettier_formatting and "Disabled" or "Enabled"
        local level = vim.b.disable_prettier_formatting and vim.log.levels.WARN or vim.log.levels.INFO
        vim.notify("Buffer Prettier " .. state, level, { title = "Formatting" })
      end,
      desc = "Toggle Prettier Formatter (Buffer)",
    },
  },
  opts = function(_, opts)
    -- Ensure the formatters table exists so we don't get nil errors
    opts.formatters = opts.formatters or {}

    -- A quick helper to check if our toggle is active
    local function is_prettier_enabled(bufnr)
      if vim.g.disable_prettier_formatting or vim.b[bufnr].disable_prettier_formatting then
        return false
      end
      return true
    end

    -- We target both prettier and prettierd, as LazyVim sometimes uses prettierd
    local target_formatters = { "prettier", "prettierd" }

    for _, formatter_name in ipairs(target_formatters) do
      opts.formatters[formatter_name] = opts.formatters[formatter_name] or {}
      if not next(opts.formatters[formatter_name]) then
        vim.notify("No formatter for " .. formatter_name, vim.log.levels.WARN, { title = "Formatting" })
        break
      end

      -- Save any existing condition LazyVim might have already set for Prettier
      -- (like checking for a .prettierrc file) so we don't break default behavior
      local original_condition = opts.formatters[formatter_name].condition

      -- Inject our custom condition
      opts.formatters[formatter_name].condition = function(self, ctx)
        -- 1. Check our custom switch first (using ctx.buf to get the buffer number)
        if not is_prettier_enabled(ctx.buf) then
          return false
        end

        -- 2. If our switch is ON, check if LazyVim had its own condition and run it
        if original_condition then
          return original_condition(self, ctx)
        end

        -- 3. If LazyVim didn't have a condition, just allow the formatter
        return true
      end
    end

    local conform = require("conform")
    if not conform._original_list_formatters then
      conform._original_list_formatters = conform.list_formatters

      -- To use it:
      -- print_function_code(original_condition)
      -- print_function_code(conform.list_formatters)

      conform.list_formatters = function(bufnr)
        -- Get the default list from Conform
        local formatters = conform._original_list_formatters(bufnr)

        -- If we toggled Prettier off, we need to force it to show up as "inactive"
        if not is_prettier_enabled(bufnr) then
          local found = false

          -- Check if it's already in the list (and force it to inactive)
          for _, f in ipairs(formatters) do
            if f.name == "prettier" or f.name == "prettierd" then
              f.available = false
              found = true
            end
          end

          -- If Conform completely dropped it from the list, manually inject it
          if not found then
            table.insert(formatters, { name = "prettier", available = false })
          end
        end

        return formatters
      end
    end
    return opts
  end,
}
