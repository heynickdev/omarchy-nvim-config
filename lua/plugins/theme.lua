local theme_path = vim.fn.stdpath("config") .. "/../omarchy/current/theme/neovim.lua"

local theme_config = dofile(theme_path)

return theme_config
