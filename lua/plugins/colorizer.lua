return {
  "norcalli/nvim-colorizer.lua",
  -- Load after you enter a buffer, which is much safer.
  -- This ensures things like filetype are already set.
  event = "VeryLazy",
  opts = {
    -- Be explicit by using the 'filetypes' key
    filetypes = {
      "css",
      "javascript",
      "javascriptreact",
      "typescriptreact", -- This is for .tsx
      "typescript",      -- Added this for .ts files, just in case
      "html",
      "tailwind",
      "templ",
      "*",
    },
    -- You could also just use '*'
    -- filetypes = { "*" },
  }
}
