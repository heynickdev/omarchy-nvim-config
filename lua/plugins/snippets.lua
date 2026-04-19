return {
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",

    dependencies = { "rafamadriz/friendly-snippets" },

    keys = {
      { "<C-s>e", function() require("luasnip").expand() end, mode = "i", desc = "Snippet: Expand" },
      { "<C-s>;", function() require("luasnip").jump(1) end, mode = { "i", "s" }, desc = "Snippet: Jump Forward" },
      { "<C-s>,", function() require("luasnip").jump(-1) end, mode = { "i", "s" }, desc = "Snippet: Jump Backward" },
      {
        "<C-E>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end,
        mode = { "i", "s" },
        desc = "Snippet: Change Choice",
      },
    },
    config = function()
      require("luasnip").filetype_extend("javascript", { "jsdoc" })
    end,
  },
}
