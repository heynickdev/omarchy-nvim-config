-- Watch for HyDE color changes and reload
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    vim.cmd("colorscheme wallbash")
  end,
})
