local uv = vim.uv or vim.loop

local M = {}

M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
M.is_linux = vim.fn.has("linux") == 1
M.is_macos = vim.fn.has("macunix") == 1

M.home = uv.os_homedir() or vim.env.HOME or vim.env.USERPROFILE or ""

function M.join(...)
  local parts = vim.tbl_filter(function(part)
    return part ~= nil and part ~= ""
  end, { ... })

  return table.concat(parts, "/")
end

function M.pub_cache()
  if M.is_windows then
    local localappdata = vim.env.LOCALAPPDATA or M.join(M.home, "AppData", "Local")
    return M.join(localappdata, "Pub", "Cache")
  end

  return M.join(M.home, ".pub-cache")
end

function M.sleep_cmd(seconds)
  seconds = seconds or 1000

  if M.is_windows then
    local shell = (vim.o.shell or ""):lower()

    if shell:find("powershell") or shell:find("pwsh") then
      return ("Start-Sleep -Seconds %d"):format(seconds)
    end

    return ("timeout /t %d /nobreak > nul"):format(seconds)
  end

  return ("sleep %d"):format(seconds)
end

function M.keep_open(cmd, seconds)
  seconds = seconds or 1000

  if M.is_windows then
    local shell = (vim.o.shell or ""):lower()

    if shell:find("powershell") or shell:find("pwsh") then
      return cmd .. "; " .. M.sleep_cmd(seconds)
    end

    return cmd .. " & " .. M.sleep_cmd(seconds)
  end

  return cmd .. " && " .. M.sleep_cmd(seconds)
end

return M
