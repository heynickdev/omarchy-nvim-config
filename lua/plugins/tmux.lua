return {
  "aserowy/tmux.nvim",
  config = function()
    local tmux = require("tmux")
    tmux.setup({
      copy_sync = {
        enable = false, -- Set to true if you want tmux/nvim clipboard syncing
      },
      navigation = {
        enable_default_keybindings = true, -- Enables Ctrl + h/j/k/l to navigate splits/panes
      },
      resize = {
        enable_default_keybindings = true, -- Enables Alt + h/j/k/l to resize splits/panes
      },
    })
  end,
}
