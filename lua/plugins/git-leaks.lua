return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    
    -- Assign gitleaks to continuously monitor code and config files for compromised secrets
    lint.linters_by_ft = {
      go = { "gitleaks" },
      python = { "gitleaks" },
      vue = { "gitleaks" },
      html = { "gitleaks" },
      javascript = { "gitleaks" },
      typescript = { "gitleaks" },
      java = { "gitleaks" },
      cs = { "gitleaks" },
      cpp = { "gitleaks" },
      yaml = { "gitleaks" },
      toml = { "gitleaks" },
      json = { "gitleaks" },
    }

    -- Trigger the security scan when leaving insert mode or saving
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("SecurityLinting", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
