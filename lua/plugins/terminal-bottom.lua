return {
  {
    "folke/snacks.nvim",
    init = function()
      local group = vim.api.nvim_create_augroup("UserTerminalBottom", {
        clear = true,
      })

      vim.api.nvim_create_autocmd("TermOpen", {
        group = group,
        callback = function(event)
          local win = vim.api.nvim_get_current_win()
          local buf = event.buf

          vim.schedule(function()
            if not vim.api.nvim_win_is_valid(win) then
              return
            end

            if not vim.api.nvim_buf_is_valid(buf) then
              return
            end

            if vim.api.nvim_win_get_buf(win) ~= buf then
              return
            end

            local config = vim.api.nvim_win_get_config(win)

            -- Do not move floating terminals.
            if config.relative ~= "" then
              return
            end

            vim.api.nvim_set_current_win(win)
            vim.cmd("wincmd J")
            vim.cmd("resize 15")

            vim.wo.number = false
            vim.wo.relativenumber = false
            vim.wo.signcolumn = "no"

            vim.cmd("startinsert")
          end)
        end,
      })
    end,
  },
}
