function fish_prompt -d "Write out the prompt"
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # No greeting
    set -g fish_greeting

    # Use starship
    starship init fish | source

    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # --- Aliases / Abbreviations ---
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias celar "printf '\033[2J\033[3J\033[1;1H'"
    alias claer "printf '\033[2J\033[3J\033[1;1H'"
    alias ls 'eza --icons'
    alias pamcan pacman
    alias q 'qs -c ii'

    abbr -a temple 'templ generate --watch --proxy="http://localhost:8080" --cmd="go run ./cmd"'
    abbr -a c 'clear'
    abbr -a homeserver "ssh mrcor@194.163.229.212"
    abbr -a server "ssh root@87.106.44.220"
    abbr -a home "ssh nick@192.168.1.153"
    abbr -a prox "ssh root@142.132.248.114"
    abbr -a python "python3"
    abbr -a py "python3"
    abbr -a p "python3"
    abbr -a v "nvim"
    abbr -a vi "nvim"
    abbr -a vim "nvim"
end
