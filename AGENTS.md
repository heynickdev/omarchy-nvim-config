# Repository Guidelines

## Overview

This repository is a personal Neovim configuration based on LazyVim 8. `init.lua` bootstraps the configuration; `lua/config/lazy.lua` loads LazyVim and every plugin specification under `lua/plugins/`.

## Layout

- `lua/config/`: editor options, keymaps, autocommands, platform helpers, and startup integration.
- `lua/plugins/`: Lazy.nvim plugin specifications and LazyVim overrides. Prefer extending an existing topic file before adding a new one.
- `colors/` and `lua/lualine/themes/`: generated/custom Matugen theme integration.
- `lazyvim.json`: enabled LazyVim extras. Keep this declarative and let LazyVim manage its schema.
- `lazy-lock.json`: plugin lockfile. Change it only through normal Lazy.nvim update/install operations.
- `backups/` and `*.backup-*`: historical snapshots; do not edit or treat them as active configuration.

## Development Conventions

- Write Lua formatted by StyLua: two spaces, 120-column width, double quotes where StyLua chooses them.
- Follow Lazy.nvim's plugin-spec shape: return a table containing the repository name and scoped `opts`, `config`, `keys`, or event fields.
- Extend upstream LazyVim options through `opts` when possible instead of replacing an entire plugin configuration.
- Keep platform-specific paths and shell behavior in `lua/config/platform.lua`; avoid hard-coded home directories.
- Add comments only for non-obvious behavior or intentional deviations from LazyVim defaults.
- Preserve unrelated local changes and generated theme files unless the task specifically concerns them.

## Validation

Run the narrowest relevant checks after editing:

```sh
stylua --check init.lua lua/
nvim --headless "+checkhealth" +qa
```

Use `stylua init.lua lua/` to format Lua changes. For plugin-resolution changes, start Neovim normally or run `nvim --headless "+Lazy! sync" +qa`; this may access the network and update `lazy-lock.json`, so only do it when dependency changes require it.

When changing keymaps, autocommands, LSP, DAP, or formatter settings, also exercise the affected command/filetype interactively when practical. Neovim may write caches and plugin data outside this repository during validation.

## Change Scope

- Keep commits focused on one configuration concern.
- Do not commit transient logs, caches, or new backup copies.
- Mention user-visible keybinding or workflow changes in the handoff or commit message.
