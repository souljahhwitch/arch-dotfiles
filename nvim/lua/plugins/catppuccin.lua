-- ~/.config/nvim/lua/plugins/catppuccin.lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- Choose your preferred flavor
        transparent_background = false,
        -- integrations = { ... }
      })
      -- Set the colorscheme immediately after setup
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
