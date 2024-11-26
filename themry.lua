require("themery").setup({
  themes = {
    {
      name = "Catppuccin Mocha",
      colorscheme = "catppuccin",
      before = [[
        vim.g.catppuccin_flavour = "mocha"
      ]],
    },
    {
      name = "Catppuccin Macchiato",
      colorscheme = "catppuccin",
      before = [[
        vim.g.catppuccin_flavour = "macchiato"
      ]],
    },
    {
      name = "Catppuccin Frappe",
      colorscheme = "catppuccin",
      before = [[
        vim.g.catppuccin_flavour = "frappe"
      ]],
    },
    {
      name = "Catppuccin Latte",
      colorscheme = "catppuccin",
      before = [[
        vim.g.catppuccin_flavour = "latte"
      ]],
    },
    {
      name = "AstroNvim Default",
      colorscheme = "astrodark",
    },
    {
      name = "TokyoNight Night",
      colorscheme = "tokyonight-night",
    },
    {
      name = "TokyoNight Storm",
      colorscheme = "tokyonight-storm",
    },
    {
      name = "TokyoNight Day",
      colorscheme = "tokyonight-day",
    },
    {
      name = "TokyoNight Moon",
      colorscheme = "tokyonight-moon",
    },

    { name = "Rose Pine", colorscheme = "rose-pine" },
    { name = "Rose Pine Moon", colorscheme = "rose-pine-moon" },
    { name = "Rose Pine Dawn", colorscheme = "rose-pine-dawn" },
  },
  themeConfigFile = "~/.config/nvim/lua/user/colorscheme.lua",
  livePreview = true,
})
