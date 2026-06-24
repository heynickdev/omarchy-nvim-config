return {
  "folke/snacks.nvim",

  keys = {
    {
      "<leader>tt",
      function()
        Snacks.terminal.toggle(nil, {
          cwd = vim.uv.cwd(),
          win = {
            position = "bottom",
            height = 0.35,
          },
        })
      end,
      desc = "Toggle Bottom Terminal",
      mode = { "n", "t" },
    },
  },

  opts = function()
    local ok, platform = pcall(require, "config.platform")

    if not ok then
      platform = {
        keep_open = function(cmd)
          return cmd
        end,
      }
    end

    local sections = {
      { section = "header" },
    }

    if vim.fn.executable("pokemon-colorscripts") == 1 then
      table.insert(sections, {
        pane = 2,
        section = "terminal",
        cmd = platform.keep_open("pokemon-colorscripts -r --no-title", 1000),
        height = 15,
        padding = 1,
        indent = 8,
      })
    end

    table.insert(sections, { section = "keys", gap = 1, padding = 1 })

    table.insert(sections, {
      pane = 2,
      icon = " ",
      desc = "Browse Repo",
      padding = 1,
      key = "b",
      action = function()
        Snacks.gitbrowse()
      end,
    })

    table.insert(sections, function()
      local in_git = Snacks.git.get_root() ~= nil
      local has_gh = vim.fn.executable("gh") == 1
      local has_git = vim.fn.executable("git") == 1

      local cmds = {
        {
          title = "Notifications",
          cmd = platform.keep_open("gh notify -s -n5", 1000),
          action = function()
            vim.ui.open("https://github.com/notifications")
          end,
          key = "n",
          icon = " ",
          height = 5,
          enabled = in_git and has_gh,
        },
        {
          title = "Open Issues",
          cmd = platform.keep_open("gh issue list -L 3", 1000),
          key = "i",
          action = function()
            vim.fn.jobstart("gh issue list --web", { detach = true })
          end,
          icon = " ",
          height = 3,
          enabled = in_git and has_gh,
        },
        {
          icon = " ",
          title = "Open PRs",
          cmd = platform.keep_open("gh pr list -L 3", 1000),
          key = "P",
          action = function()
            vim.fn.jobstart("gh pr list --web", { detach = true })
          end,
          height = 3,
          enabled = in_git and has_gh,
        },
        {
          icon = " ",
          title = "Git Status",
          cmd = platform.keep_open("git --no-pager diff --stat -B -M -C", 1000),
          height = 5,
          enabled = in_git and has_git,
        },
      }

      return vim.tbl_map(function(cmd)
        return vim.tbl_extend("force", {
          pane = 2,
          section = "terminal",
          padding = 1,
          ttl = 5 * 60,
          indent = 2,
        }, cmd)
      end, cmds)
    end)

    table.insert(sections, { section = "startup" })

    return {
      scroll = {
        enabled = false,
      },

      terminal = {
        win = {
          position = "bottom",
          height = 0.35,
        },
      },

      dashboard = {
        enabled = true,
        sections = sections,
      },
    }
  end,
}
