-- for extra plugins -- 
local M = {}

-- add extra plugins here
M.plugins = {
  { "Shatur/neovim-ayu" },

  {
"OXY2DEV/markview.nvim",
lazy = false, -- Changed from true to false as recommended
ft = { "markdown", "typst", "latex", "yaml", "html" }, -- Added filetype loading
-- If you use blink.cmp for completion, uncomment the next line:
-- dependencies = { "saghen/blink.cmp" },
config = function()
require("markview").setup({
preview = {
icon_provider = "internal", -- or "mini" or "devicons"
},
-- Add further customization here as needed
})
end,
keys = {
{
"<leader>mp",
function()
vim.cmd("Markview preview")
end,
desc = "Markdown Preview (Markview)",
},
},
}


}

-- add extra configuration options here, like extra autocmds etc.
-- feel free to create your own separate files and require them in here
M.configs = function() require("ayu").colorscheme() end

-- add servers to be used for auto formatting here
M.formatting_servers = {
  rust_analyzer = {},
  lua_ls = {},
}

-- add Tree-sitter to auto-install
M.ensure_installed = { "toml" }

-- add any null-ls sources you want here
M.setup_sources = function(b)
  return {
    b.formatting.autopep8,
    b.formatting.prettier.with {
      extra_filetypes = { "toml" },
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    },
    b.formatting.black.with {
      extra_args = { "--fast" },
    },
    b.formatting.stylua,
  }
end

return M
