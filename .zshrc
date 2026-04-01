# ===================================================================
# OPTIONS & HISTORY
# ===================================================================

setopt EXTENDED_GLOB NULL_GLOB SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"

# ===================================================================
# ENVIRONMENT
# ===================================================================

export ANDROID_HOME="$HOME/Android/Sdk"
export CAPACITOR_ANDROID_STUDIO_PATH="/mnt/c/Program Files/Android/Android Studio/bin/studio64.exe"
export ADB="/mnt/c/Android/Sdk/platform-tools/adb.exe"
export EMULATOR="/mnt/c/Android/Sdk/emulator/emulator.exe"

if command -v asdf >/dev/null 2>&1; then
  export JAVA_HOME=$(asdf where java 2>/dev/null || echo "")
  if [[ -n "$JAVA_HOME" ]]; then
    export PATH="$JAVA_HOME/bin:$PATH"
  fi
fi

export TERM="xterm-256color"
export EDITOR="nvim"

# --- PATH Management ---
pathadd() {
  local dir
  for dir in "$@"; do
    [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]] && PATH="$dir:$PATH"
  done
}

local paths=(
  ${ASDF_DATA_DIR:-$HOME/.asdf}/shims
  $HOME/.local/bin
  $HOME/.opencode/bin
  $HOME/develop/flutter/bin
  $HOME/vcpkg
  $HOME/cmake-4.1.2-linux-x86_64/bin/
  /opt/bin
  /opt/mssql-tools18/bin
)

pathadd "${paths[@]}"
export PATH

showpath() { print -l ${(s/:/)PATH}; }

# ===================================================================
# ANTIDOTE
# ===================================================================

source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# ===================================================================
# PURE PROMPT
# ===================================================================

fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure

# ===================================================================
# ASDF (Version Manager)
# ===================================================================

if [[ -s "/usr/local/bin/asdf" ]]; then
  mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
  fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
fi

# ===================================================================
# TOOLS
# ===================================================================

(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# ===================================================================
# KEY BINDINGS
# ===================================================================

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^H' backward-kill-word
bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word


# ===================================================================
# ALIASES
# ===================================================================

# Navigation & tools
alias ls='ls --color'
alias l='ls -ltrah'
alias lg='lazygit'
alias ldo='lazydocker'
alias n='nvim'
alias py='python'

# Build helpers
alias mmi='make && make install'
alias mcmu='make clean && make uninstall'
alias mcmummi='make clean && make uninstall && make && make install'
alias bm='bear -- make'
alias bmmi='bear -- make && make install'

# Config shortcuts
alias zconfig='nvim ~/.zshrc && source ~/.zshrc'
alias secconfig='vim ~/secrets.sh && source ~/secrets.sh'
alias tconfig='cd ~/.config/tmux && vim tmux.conf'
alias kittyconfig='cd ~/.config/kitty && vim kitty.conf'
alias nvimconfig='cd ~/.config/nvim && nvim .'

# Misc
alias rm='trash'
alias chat='sgpt --repl temp'
alias quicknote='touch $HOME/quicknotes/$(date +"%Y-%m-%d").md && cd quicknotes && nvim $(date +"%Y-%m-%d").md'
alias adb=$ADB
alias emulator=$EMULATOR

# ===================================================================
# COMPLETIONS
# ===================================================================

if (( $+commands[docker] )); then
  source <(docker completion zsh)
fi

if (( $+commands[codex] )); then
  source <(codex completion zsh)
fi

if (( $+commands[hugo] )); then
  source <(hugo completion zsh)
fi

if (( $+commands[kind] )); then
  source <(kind completion zsh)
fi

if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
fi

autoload -Uz compinit
compinit -d ~/.cache/zcompdump

autoload -Uz bashcompinit
bashcompinit

if (( $+commands[aws_completer] )); then
  complete -C aws_completer aws
fi

if (( $+commands[terraform] )); then
  complete -o nospace -C /usr/bin/terraform terraform
fi

# ===================================================================
# FUNCTIONS
# ==================================================================
dopg() {                                                                     
  export PATH="/home/daniel/develop/pg/bin:$PATH"                        
  export LD_LIBRARY_PATH="/home/daniel/develop/pg/lib:$LD_LIBRARY_PATH"  
  alias pgstart="pg_ctl -D /home/daniel/develop/pgdata/1/ -l /home/daniel/develop/pgdata/1/logfile start"                        
  alias pgrestart="pg_ctl -D /home/daniel/develop/pgdata/1/ -l /home/daniel/develop/pgdata/1/logfile restart"                      
  alias pgstop="pg_ctl -D /home/daniel/develop/pgdata/1/ -l /home/daniel/develop/pgdata/1/logfile stop"                         
}

newgo() {
  [[ $# -eq 0 ]] && { echo "Usage: newgo <module_name>"; return 1; }
  local m="$1"
  mkdir -p "$m" && cd "$m" \
    && go mod init "$m" \
    && printf '%s\n' "package main" "" "import \"fmt\"" "" \
       "func main() {" "    fmt.Println(\"Hello, $m!\")" "}" > main.go \
    && echo "New Go module '$m' created"
}

remove-nvim-swap-files() {
  rm -rf ~/.local/state/nvim/swap/*
}

t() {
    local selected=$( (tmux list-sessions -F "#{session_name}" 2>/dev/null; echo " New Session") | fzf --reverse --height=40% )
    [[ -z "$selected" ]] && return

    if [[ "$selected" == " New Session" ]]; then
        printf "Enter Session Name: "
        read session_name
        [[ -z "$session_name" ]] && return

        printf "Enter Window Name: "
        read window_name
        [[ -z "$window_name" ]] && window_name="main"

        tmux new-session -ds "$session_name" -n "$window_name"
        selected="$session_name"
    fi

    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$selected"
    else
        tmux attach-session -t "$selected"
    fi
}

_t_completion() {
  local -a sessions
  sessions=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
  compadd -a sessions
}
compdef _t_completion t

notify-send() {
    wsl-notify-send.exe --category "$1" "$2"
}

## RUST
. "$HOME/.cargo/env"

# ===================================================================
# LOAD SECRETS
# ===================================================================

[[ -f ~/secrets.sh ]] && source ~/secrets.sh
