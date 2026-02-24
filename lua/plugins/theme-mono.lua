-- Manga Monochrome Theme for Neovim (Ink & Paper)
-- Derived from Aetheria structure for LazyVim

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        -- High-contrast grayscale palette
        local colors = {
          -- Backgrounds (Ink)
          bg_dark      = "#000000", -- Pure Black
          bg_main      = "#0a0a0a", -- Near Black
          bg_float     = "#121212", -- Deep Gray
          bg_visual    = "#333333", -- Screentone Gray
          
          -- Borders & Shading
          shade_dark   = "#444444", -- Darker Screentone
          shade_mid    = "#888888", -- Neutral Gray
          shade_light  = "#bbbbbb", -- Light Gray
          
          -- Foregrounds (Paper)
          fg_main      = "#ffffff", -- Pure White
          fg_dim       = "#dddddd", -- Off White
          fg_ghost     = "#666666", -- Faded Ink (Comments)
        }

        vim.cmd("highlight clear")
        if vim.fn.exists("syntax_on") then
          vim.cmd("syntax reset")
        end

        vim.o.termguicolors = true
        vim.o.background = "dark"
        vim.g.colors_name = "manga-noir"

        local hl = vim.api.nvim_set_hl

        -- Editor highlights (The "Panel" Look)
        hl(0, "Normal", { fg = colors.fg_main, bg = colors.bg_main })
        hl(0, "NormalFloat", { fg = colors.fg_main, bg = colors.bg_float })
        hl(0, "FloatBorder", { fg = colors.fg_main, bg = colors.bg_float })
        hl(0, "FloatTitle", { fg = colors.bg_dark, bg = colors.fg_main, bold = true })
        hl(0, "Cursor", { fg = colors.bg_dark, bg = colors.fg_main })
        hl(0, "CursorLine", { bg = colors.bg_float })
        hl(0, "CursorLineNr", { fg = colors.fg_main, bold = true })
        hl(0, "LineNr", { fg = colors.shade_dark })
        hl(0, "Visual", { bg = colors.bg_visual })
        hl(0, "Search", { fg = colors.bg_dark, bg = colors.shade_light })
        hl(0, "IncSearch", { fg = colors.bg_dark, bg = colors.fg_main })
        hl(0, "MatchParen", { fg = colors.fg_main, bg = colors.shade_dark, bold = true })

        -- Syntax (Manga Logic: Bold vs Regular vs Italic)
        hl(0, "Comment", { fg = colors.fg_ghost, italic = true })
        hl(0, "Constant", { fg = colors.fg_main, bold = true })
        hl(0, "String", { fg = colors.shade_light })
        hl(0, "Identifier", { fg = colors.fg_main })
        hl(0, "Function", { fg = colors.fg_main, bold = true })
        hl(0, "Statement", { fg = colors.fg_main, bold = true })
        hl(0, "Keyword", { fg = colors.fg_main, bold = true })
        hl(0, "PreProc", { fg = colors.shade_light })
        hl(0, "Type", { fg = colors.fg_main, italic = true })
        hl(0, "Special", { fg = colors.shade_light })
        hl(0, "Delimiter", { fg = colors.shade_mid })
        hl(0, "Operator", { fg = colors.fg_main })

        -- UI Elements
        hl(0, "WinSeparator", { fg = colors.shade_dark })
        hl(0, "Pmenu", { fg = colors.fg_dim, bg = colors.bg_float })
        hl(0, "PmenuSel", { fg = colors.bg_dark, bg = colors.fg_main, bold = true })
        hl(0, "StatusLine", { fg = colors.fg_main, bg = colors.bg_dark })

        -- Treesitter (Fine-tuning the grayscale)
        hl(0, "@variable", { fg = colors.fg_main })
        hl(0, "@variable.builtin", { fg = colors.fg_main, italic = true })
        hl(0, "@property", { fg = colors.shade_light })
        hl(0, "@constructor", { fg = colors.fg_main, bold = true })
        hl(0, "@keyword.return", { fg = colors.fg_main, bold = true, italic = true })

        -- Terminal Colors (Purely grayscale)
        for i = 0, 15 do
          local gray = string.format("#%02x%02x%02x", i*16+15, i*16+15, i*16+15)
          vim.g["terminal_color_" .. i] = gray
        end
        -- Adjusting specific terminal colors for visibility
        vim.g.terminal_color_0 = colors.bg_dark
        vim.g.terminal_color_7 = colors.shade_light
        vim.g.terminal_color_15 = colors.fg_main
      end,
    },
  },
}
