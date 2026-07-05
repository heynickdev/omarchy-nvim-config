local M = {}

local state = _G.__dms_theme_reload or {}
_G.__dms_theme_reload = state

local uv = vim.uv or vim.loop
local theme_file = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
local theme_dir = vim.fn.fnamemodify(theme_file, ":h")
local theme_name = vim.fn.fnamemodify(theme_file, ":t")

local function apply_theme()
  local ok, spec = pcall(dofile, theme_file)

  if not ok then
    vim.notify(spec, vim.log.levels.ERROR, { title = "dankcolors" })
    return
  end

  if spec and spec[1] and spec[1].config then
    spec[1].config()
    vim.g.colors_name = "dankcolors"
    vim.notify("DMS theme reloaded", vim.log.levels.INFO, { title = "dankcolors" })
  end
end

local function start_watcher()
  if state.watcher then
    state.watcher:stop()
  else
    state.watcher = uv.new_fs_event()
  end

  state.watcher:start(
    theme_dir,
    {},
    vim.schedule_wrap(function(_, filename)
      if filename and filename ~= theme_name then
        return
      end

      state.timer:stop()
      state.timer:start(150, 0, vim.schedule_wrap(apply_theme))
    end)
  )
end

function M.setup()
  if state.started then
    return
  end

  state.started = true
  state.timer = state.timer or uv.new_timer()
  start_watcher()
end

return M
