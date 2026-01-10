-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local function async_copy(lines)
  local stdin = vim.uv.new_pipe()
  local stderr = vim.uv.new_pipe()
  vim.uv.spawn("win32yank.exe", {
    args = { "-i", "--crlf" },
    stdio = { stdin, nil, stderr },
  }, function(code, signal)
    if code == 0 then
      vim.notify("Async Copy To Windows Clipboard Success", vim.log.levels.INFO)
    end
  end)

  vim.uv.write(stdin, table.concat(lines, "\n"), function(err)
    if err then
      vim.notify("Write error: " .. err, vim.log.levels.ERROR)
    end
    vim.uv.close(stdin)
  end)

  vim.uv.read_start(stderr, function(err, data)
    assert(not err, err)
    if data then
      vim.notify("stderr async_copy chunk: " .. data, vim.log.levels.ERROR)
    end
    vim.uv.close(stderr)
  end)
end

if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "win32clipboard",
    copy = {
      ["+"] = async_copy,
      ["*"] = async_copy,
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end

vim.opt.cursorline = false
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#e4e022", bg = "NONE" })
