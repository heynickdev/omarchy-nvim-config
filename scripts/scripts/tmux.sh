#!/bin/bash

t() {
  # The first argument is either a command (kill, ls, exit, help) or a session name.
  local arg1="$1"
  # The second argument is the session name (only used with 'kill').
  local session_name="$2"

  # Helper function to check if a tmux session exists
  tmux_session_exists() {
    tmux has-session -t "$1" 2>/dev/null
  }

  case "$arg1" in
    # --- kill command: kill a session or the current one ---
    "kill")
      if [ -z "$session_name" ]; then
        # No session name provided, try to kill the currently attached session
        if [ -n "$TMUX" ]; then
          # Extract the current session name from the TMUX environment variable
          local current_session
          current_session=$(tmux display-message -p '#S')
          echo "🪦 Killing current tmux session: **$current_session**"
          tmux kill-session -t "$current_session"
        else
          echo "⚠️ Not currently in a tmux session. Use 't kill <name>'."
        fi
      else
        # Kill the specified session
        if tmux_session_exists "$session_name"; then
          echo "🪦 Killing tmux session: **$session_name**"
          tmux kill-session -t "$session_name"
        else
          echo "❌ Tmux session **$session_name** does not exist."
          return 1
        fi
      fi
      ;;

    # --- exit command: detach current session ---
    "exit")
      if [ -n "$TMUX" ]; then
        echo "🚪 Detaching from current session. It remains running."
        tmux detach
      else
        echo "⚠️ Not currently in a tmux session to exit."
        return 1
      fi
      ;;

    # --- Standard commands (ls, help) ---
    "ls")
      tmux ls
      ;;
      
    "help")
      echo "Usage: t [session-name] (Auto-attach/Create)"
      echo "  or: t <command> [session-name]"
      echo
      echo "Commands:"
      echo "  <session-name>  Attach to **<session-name>**, creating it if it doesn't exist."
      echo "  kill [session]  Kill the named session, or the **current** one if no name is given."
      echo "  exit            **Detach** (exit) the current session, leaving it running in the background."
      echo "  ls              List all sessions."
      echo "  help            Show this usage information."
      ;;

    # --- No argument: list sessions (New default behavior) ---
    "")
      tmux ls
      ;;

    # --- Default case: Assume $1 is a session name for auto-attach/create ---
    *)
      # Check if an explicit command was used with a second argument, which is an error
      if [ -n "$session_name" ]; then
          echo "❌ Error: Unknown command **$arg1**"
          echo "To attach, use: t <session-name>"
          return 1
      fi

      local target_session="$arg1"
      
      if tmux_session_exists "$target_session"; then
        echo "🔗 Attaching to existing tmux session: **$target_session**"
        tmux attach -t "$target_session"
      else
        echo "➕ Creating and attaching to new tmux session: **$target_session**"
        tmux new -s "$target_session"
      fi
      ;;
  esac
}
