local map = vim.keymap.set
local cmd = vim.cmd

-- ============================================================================
-- General mappings
-- ============================================================================

-- Save and quit
map("n", "<leader>q", ":qa!<CR>", { desc = "Quit all without saving" })
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })

-- Window navigation
map("n", "<leader>h", "<C-w>h", { desc = "Window left" })
map("n", "<leader>j", "<C-w>j", { desc = "Window down" })
map("n", "<leader>k", "<C-w>k", { desc = "Window up" })
map("n", "<leader>l", "<C-w>l", { desc = "Window right" })

-- Window splits
map("n", "<leader>v", ":vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>s", ":split<CR>", { desc = "Split horizontally" })
map("n", "<leader>c", ":close<CR>", { desc = "Close window" })
map("n", "<leader>o", ":only<CR>", { desc = "Close other windows" })

-- Window resizing
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- ============================================================================
-- Buffer navigation
-- ============================================================================

map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bD", ":bdelete!<CR>", { desc = "Force delete buffer" })
map("n", "<leader>ba", ":%bd|e#|bd#<CR>", { desc = "Delete all buffers except current" })

-- ============================================================================
-- Text editing
-- ============================================================================

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move text up and down
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better paste
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Clear search highlighting
map("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlights" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- ============================================================================
-- Configuration reload
-- ============================================================================

function _G.reload_config()
  local reload = require("plenary.reload").reload_module
  reload("me", false)
  dofile(vim.env.MYVIMRC)
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end

map("n", "<leader>rr", _G.reload_config, { desc = "Reload configuration" })

-- ============================================================================
-- Telescope
-- ============================================================================

local builtin = require("telescope.builtin")
map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "List buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
map("n", "<leader>fo", builtin.oldfiles, { desc = "Recent files" })
map("n", "<leader>fw", builtin.grep_string, { desc = "Find word under cursor" })
map("n", "<leader>cm", builtin.git_commits, { desc = "Git commits" })
map("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
map("n", "<leader>fc", builtin.colorscheme, { desc = "Change colorscheme" })
map("n", "<leader>fk", builtin.keymaps, { desc = "Show keymaps" })

-- ============================================================================
-- NvimTree
-- ============================================================================

map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>er", ":NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
map("n", "<leader>ef", ":NvimTreeFindFile<CR>", { desc = "Find file in explorer" })

-- ============================================================================
-- LSP
-- ============================================================================

map("n", "<leader>gf", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "Format file" })

-- Diagnostic mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- ============================================================================
-- Comment
-- ============================================================================

map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- ============================================================================
-- Terminal
-- ============================================================================

local terminal_buf = nil

local function toggle_terminal()
  -- Check if terminal buffer exists and is valid
  if terminal_buf and vim.api.nvim_buf_is_valid(terminal_buf) then
    -- Check if terminal is currently visible in any window
    local terminal_visible = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == terminal_buf then
        -- Terminal is visible, hide it
        vim.api.nvim_win_close(win, false)
        terminal_visible = true
        break
      end
    end

    if terminal_visible then
      return
    end
  end

  -- Show or create terminal
  local height = math.floor(vim.o.lines / 2)
  cmd("belowright split")
  cmd("resize " .. height)

  if terminal_buf and vim.api.nvim_buf_is_valid(terminal_buf) then
    -- Reuse existing terminal buffer
    vim.api.nvim_win_set_buf(0, terminal_buf)
  else
    -- Create new terminal
    cmd("terminal")
    terminal_buf = vim.api.nvim_get_current_buf()
  end
end

map("n", "<C-\\>", toggle_terminal, { desc = "Toggle terminal" })

-- Other terminal options (kept for flexibility)
map("n", "<leader>th", function()
  local height = math.floor(vim.o.lines / 2)
  cmd("belowright split | resize " .. height .. " | terminal")
end, { desc = "Horizontal terminal" })

map("n", "<leader>tv", function()
  cmd("vsplit | terminal")
end, { desc = "Vertical terminal" })

map("n", "<leader>tf", function()
  cmd("terminal")
end, { desc = "Fullscreen terminal" })

-- Terminal mode mappings
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to bottom window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to top window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })

-- ============================================================================
-- Git
-- ============================================================================

map("n", "<leader>gg", ":Git<CR>", { desc = "Open Git" })
map("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
map("n", "<leader>gd", ":Gdiffsplit<CR>", { desc = "Git diff" })

-- ============================================================================
-- Quick actions
-- ============================================================================

-- Toggle line numbers
map("n", "<leader>tn", ":set nu!<CR>", { desc = "Toggle line numbers" })
map("n", "<leader>tr", ":set rnu!<CR>", { desc = "Toggle relative numbers" })

-- Toggle wrap
map("n", "<leader>tw", ":set wrap!<CR>", { desc = "Toggle line wrap" })

-- Toggle spell check
map("n", "<leader>ts", ":set spell!<CR>", { desc = "Toggle spell check" })

-- Center screen on navigation
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })



-- Quickfix navigation
map("n", "[q", ":cprev<CR>", { desc = "Previous quickfix" })
map("n", "]q", ":cnext<CR>", { desc = "Next quickfix" })

-- Location list navigation
map("n", "[l", ":lprev<CR>", { desc = "Previous location" })
map("n", "]l", ":lnext<CR>", { desc = "Next location" })

-- Yank to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })

-- Paste from system clipboard
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste before from clipboard" })
