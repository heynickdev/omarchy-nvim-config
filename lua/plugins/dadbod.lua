return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    -- Configures Dadbod to use Nerd Fonts for UI elements
    vim.g.db_ui_use_nerd_fonts = 1
    -- Prevents standard mappings from conflicting with Dadbod
    vim.g.db_ui_show_help = 0
    vim.g.db_ui_win_position = "right"
  end,
  keys = {
    { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Toggle Database UI" },
  },
}
