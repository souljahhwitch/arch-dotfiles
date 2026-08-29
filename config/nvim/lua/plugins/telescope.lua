-- lua/plugins/telescope.lua
return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8', -- It's good practice to use the latest stable tag if possible, e.g., '0.1.x' or '0.1.8'
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require("telescope.builtin")

    -- Set the leader key here as well, although it's okay to have it in init.lua too.
    -- Having it in init.lua is generally preferred for global settings.
    -- vim.g.mapleader = " " -- This line can stay in init.lua or be put here, but best practice is init.lua for global.

    -- These keymaps now run AFTER Telescope is loaded
    vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = "Find Files" })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep" })

    -- Optional: If you want to add general Telescope setup options
    -- require("telescope").setup({
    --   defaults = {
    --     -- Your default settings here
    --   },
    -- })
  end,
}
