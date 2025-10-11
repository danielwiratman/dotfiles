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
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
export TERM="xterm-256color"

# --- PATH Management ---
pathadd() {
  local dir
  for dir in "$@"; do
    [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]] && PATH="$dir:$PATH"
  done
}

local paths=(
  $HOME/.local/bin
  /opt/bin
  ${ASDF_DATA_DIR:-$HOME/.asdf}/shims
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

if [[ -s "/opt/bin/asdf" ]]; then
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

# ===================================================================
# COMPLETIONS
# ===================================================================

if (( $+commands[docker] )); then
  source <(docker completion zsh)
fi

autoload -Uz compinit
compinit -d ~/.cache/zcompdump

# ===================================================================
# FUNCTIONS
# ==================================================================
dopg() {                                                                     
  export PATH="/home/daniel/development/pg/bin:$PATH"                        
  export LD_LIBRARY_PATH="/home/daniel/development/pg/lib:$LD_LIBRARY_PATH"  
  alias pgstart="pg_ctl -D /home/daniel/development/datadir/data1/ -l /home/daniel/development/datadir/data1/logfile start"                        
  alias pgrestart="pg_ctl -D /home/daniel/development/datadir/data1/ -l /home/daniel/development/datadir/data1/logfile restart"                      
  alias pgstop="pg_ctl -D /home/daniel/development/datadir/data1/ -l /home/daniel/development/datadir/data1/logfile stop"                         
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



# ===================================================================
# LOAD SECRETS
# ===================================================================

[[ -f ~/secrets.sh ]] && source ~/secrets.sh
