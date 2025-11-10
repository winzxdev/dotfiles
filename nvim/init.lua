-- Check if we're running Neovim (not regular Vim)
if not vim.fn.has("nvim") then
  error("This config requires Neovim. Please use Neovim instead of Vim.")
end

-- Check Neovim version (recommend 0.8+, but allow older versions)
local nvim_version = vim.version()
if nvim_version and (nvim_version.major == 0 and nvim_version.minor < 7) then
  vim.notify("Warning: Neovim 0.7+ recommended for best compatibility", vim.log.levels.WARN)
end

-- Check for required external tools
for _, cmd in ipairs { "git", "rg", { "fd", "fdfind" } } do
  local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
  local commands = type(cmd) == "string" and { cmd } or cmd
  local found = false

  for _, c in ipairs(commands) do
    if vim.fn.executable(c) == 1 then
      name = c
      found = true
      break
    end
  end

  if not found then
    vim.notify(string.format("`%s` is not installed. Some features may not work.", name), vim.log.levels.WARN)
  end
end

-- Enable 24-bit RGB colors if supported
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

-- Disable deprecation warnings (if vim.deprecate exists)
if vim.deprecate then
  vim.deprecate = function() end
end

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Use vim.loop or vim.uv depending on version
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
  vim.notify("Installing lazy.nvim plugin manager...", vim.log.levels.INFO)
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Load default configurations and plugins
for _, source in ipairs({
  "plugins",
  "options",
  "mappings",
  "autocmds",
}) do
  local ok, fault = pcall(require, source)
  if not ok then
    local msg = "Failed to load " .. source .. "\n\n" .. tostring(fault)
    -- Use vim.notify for better compatibility
    if vim.notify then
      vim.notify(msg, vim.log.levels.ERROR)
    else
      vim.api.nvim_err_writeln(msg)
    end
  end
end

-- Load custom configurations if they exist
local ok, custom = pcall(require, "custom")
if ok and type(custom) == "table" and custom.configs then
  pcall(custom.configs)
end
