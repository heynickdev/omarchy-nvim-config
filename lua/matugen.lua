 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#1a1110',
    base01 = '#271d1c',
    base02 = '#322827',
    base03 = '#a08c8a',
    base04 = '#d8c2bf',
    base05 = '#f1dedd',
    base06 = '#f1dedd',
    base07 = '#f1dedd',
    base08 = '#ffb4ab',
    base09 = '#e1c28c',
    base0A = '#e7bdb9',
    base0B = '#ffb3ad',
    base0C = '#e1c28c',
    base0D = '#ffb3ad',
    base0E = '#e7bdb9',
    base0F = '#93000a',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f1dedd',          bg = '#1a1110' })
  hi('TelescopeBorder',         { fg = '#a08c8a',             bg = '#1a1110' })
  hi('TelescopePromptNormal',   { fg = '#f1dedd',          bg = '#1a1110' })
  hi('TelescopePromptBorder',   { fg = '#a08c8a',             bg = '#1a1110' })
  hi('TelescopePromptPrefix',   { fg = '#ffb3ad',             bg = '#1a1110' })
  hi('TelescopePromptCounter',  { fg = '#d8c2bf',  bg = '#1a1110' })
  hi('TelescopePromptTitle',    { fg = '#1a1110',             bg = '#ffb3ad' })
  hi('TelescopePreviewTitle',   { fg = '#1a1110',             bg = '#e7bdb9' })
  hi('TelescopeResultsTitle',   { fg = '#1a1110',             bg = '#e1c28c' })
  hi('TelescopeSelection',      { fg = '#f1dedd',          bg = '#322827' })
  hi('TelescopeSelectionCaret', { fg = '#ffb3ad',             bg = '#322827' })
  hi('TelescopeMatching',       { fg = '#ffb3ad',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
