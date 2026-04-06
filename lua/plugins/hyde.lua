return {
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      -- Force 'wallbash' as the theme
      opts.colorscheme = "wallbash"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      -- This ensures that every time the theme reloads, we fix the styling
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "wallbash",
        callback = function()
          local hl = vim.api.nvim_set_hl

          -- 1. CLEAN TRANSPARENCY (Matches your Hyprland glass/blur)
          local groups = {
            "Normal",
            "NormalFloat",
            "FloatBorder",
            "Pmenu",
            "SignColumn",
            "FoldColumn",
            "StatusLine",
            "StatusLineNC",
            "TelescopeNormal",
            "TelescopeBorder",
            "NeoTreeNormal",
          }
          for _, g in ipairs(groups) do
            hl(0, g, { bg = "NONE", ctermbg = "NONE" })
          end

          -- 2. BETTER TREESITTER MAPPING
          -- This maps HyDE's base colors to modern syntax groups
          local links = {
            ["@function"] = "Function",
            ["@method"] = "Function",
            ["@keyword"] = "Keyword",
            ["@variable"] = "Identifier",
            ["@variable.builtin"] = "Identifier",
            ["@string"] = "String",
            ["@type"] = "Type",
            ["@constant"] = "Constant",
            ["@comment"] = "Comment",
            ["@operator"] = "Operator",
            ["@property"] = "Identifier",
            ["@field"] = "Identifier",
            ["@parameter"] = "Identifier",
            ["@punctuation.bracket"] = "Delimiter",
          }
          for ts, vim_hl in pairs(links) do
            hl(0, ts, { link = vim_hl })
          end

          -- Set comments to italic for that premium feel
          hl(0, "Comment", { italic = true })
        end,
      })
    end,
  },
}
