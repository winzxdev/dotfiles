
local null_ls = require "null-ls"

-- Load custom configurations
local exist, custom = pcall(require, "custom")
local sources = exist and type(custom) == "table" and custom.setup_sources and custom.setup_sources(null_ls.builtins)
    or {}

null_ls.setup {
    debug = false,
    sources = sources,
}
