return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- or "mocha", etc.
        transparent_background = true,

        custom_highlights = function(colors)
          return {
            -- Normal text
            Normal = { fg = "#d399a1", bg = "NONE" },

            -- Floating windows
            NormalFloat = { fg = "#d399a1", bg = "NONE" },
            FloatBorder = { fg = "#d399a1", bg = "NONE" },

            -- Popup menus
            Pmenu = { fg = "#d399a1", bg = "NONE" },
            PmenuSel = { fg = "#1e1e2e", bg = "#d399a1" },

            -- Borders and lines
            WinSeparator = { fg = "#d399a1" },
            VertSplit = { fg = "#d399a1" },
            StatusLine = { fg = "#d399a1", bg = "NONE" },
            StatusLineNC = { fg = "#d399a1", bg = "NONE" },

            -- Telescope (if you use it)
            TelescopeBorder = { fg = "#d399a1" },
            TelescopeNormal = { fg = "#d399a1" },

            -- LSP floating windows
            LspInfoBorder = { fg = "#d399a1" },
          }
        end,
      })

      -- Set the colorscheme
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
