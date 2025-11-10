-- Mason setup - fix for duplicate registry
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup({
      -- Remove or comment out any registries configuration if present
      -- registries = { ... }  -- DELETE THIS if you have it

      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",   -- Lua
        "bashls",   -- Bash
        "dockerls", -- Docker
        "jsonls",   -- JSON
        -- "yamlls",   -- YAML
        -- "vimls",    -- Vim
        -- "gopls",         -- Uncomment after installing Go
      },
      automatic_installation = true,
    })
  end,
}
