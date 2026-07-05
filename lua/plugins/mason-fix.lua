local function remove_items(list, blocked)
  if type(list) ~= "table" then
    return {}
  end

  return vim.tbl_filter(function(item)
    local name = type(item) == "table" and item[1] or item
    return not blocked[name]
  end, list)
end

local blocked = {
  jdtls = true,
  ["java-language-server"] = true,
  java_language_server = true,

  -- Keep this blocked unless you actually want F# tooling
  fsautocomplete = true,
}

return {
  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = remove_items(opts.ensure_installed, blocked)

      opts.automatic_enable = opts.automatic_enable or {}
      opts.automatic_enable.exclude = vim.tbl_extend("force", opts.automatic_enable.exclude or {}, {
        "jdtls",
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = remove_items(opts.ensure_installed, blocked)

      opts.automatic_enable = opts.automatic_enable or {}
      opts.automatic_enable.exclude = vim.tbl_extend("force", opts.automatic_enable.exclude or {}, {
        "jdtls",
      })
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = remove_items(opts.ensure_installed, blocked)
    end,
  },
}
