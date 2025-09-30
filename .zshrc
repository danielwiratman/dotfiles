# ===================================================================
# ULTRA-FAST ZSHRC - MAXIMUM PERFORMANCE
# ===================================================================

# Disable compinit security check (saves ~100ms)
ZSH_DISABLE_COMPFIX=true

# ===================================================================
# PATHS - Single concatenation
# ===================================================================

typeset -U path  # Keep unique paths only
path=(
  $HOME/.local/bin
  $HOME/go/bin
  $HOME/.rbenv/bin
  $ANDROID_HOME/platform-tools
  $ANDROID_HOME/emulator
  $ANDROID_HOME/cmdline-tools
  $JAVA_HOME/bin
  $BUN_INSTALL/bin
  /opt/{nvim,resolve,scrcpy}
  /opt/{gradle/gradle-8.10.2,binsider-0.1.0,apache-maven-3.9.9}/bin
  /usr/local/go/bin
  /usr/bin/android-studio/bin
  $HOME/development/flutter/bin
  $HOME/.yarn/bin
  $path
)

# Export vars once
export ANDROID_HOME="$HOME/Android/Sdk" \
       JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64" \
       BUN_INSTALL="$HOME/.bun" \
       NVM_DIR="$HOME/.nvm" \
       CHROME_EXECUTABLE="/usr/bin/google-chrome-stable" \
       LD_LIBRARY_PATH="/usr/local/lib" \
       GEMINI_MODEL="gemini-2.5-flash" \
       TERM="xterm-256color"

# ===================================================================
# HISTORY - Fast settings
# ===================================================================

HISTSIZE=50000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=50000
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_SPACE HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS HIST_FIND_NO_DUPS

# ===================================================================
# ZINIT - Turbo mode everything
# ===================================================================

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ ! -d $ZINIT_HOME ]] && mkdir -p "$(dirname $ZINIT_HOME)" && git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"

# Turbo mode - all plugins load asynchronously after prompt
zinit wait lucid for \
  OMZP::git \
  OMZP::sudo \
  OMZP::command-not-found

zinit wait lucid light-mode for \
  atinit"typeset -gA FAST_HIGHLIGHT; FAST_HIGHLIGHT[git-cmsg-len]=100" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions \
    Aloxaf/fzf-tab

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
# ALIASES - Fast and simple
# ===================================================================

alias ls='ls --color' l='ls -ltrah' lg='lazygit' ldo='lazydocker' py='python' n='nvim'
alias mmi='make && make install' mcmu='make clean && make uninstall' 
alias mcmummi='make clean && make uninstall && make && make install'
alias bm='bear -- make' bmmi='bear -- make && make install' rm='trash'
alias zconfig='nvim ~/.zshrc && source ~/.zshrc' secconfig='vim ~/secrets.sh && source ~/secrets.sh'
alias tconfig='cd ~/.config/tmux && vim tmux.conf' kittyconfig='cd ~/.config/kitty && vim kitty.conf'
alias nvimconfig='cd ~/.config/nvim && nvim .' chat='sgpt --repl temp'

# ===================================================================
# LAZY LOADERS - Zero-cost until first use
# ===================================================================

# Conda lazy loader
_load_conda() {
  unfunction python python3 conda pip pip3 2>/dev/null
  if [[ -f "$HOME/miniconda3/bin/conda" ]]; then
    __conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2>/dev/null)"
    [[ $? -eq 0 ]] && eval "$__conda_setup" || {
      [[ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]] && . "$HOME/miniconda3/etc/profile.d/conda.sh" || export PATH="$HOME/miniconda3/bin:$PATH"
    }
    unset __conda_setup
  fi
}

# NVM lazy loader
_load_nvm() {
  unfunction node npm npx nvm 2>/dev/null
  [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh" --no-use
  [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
}

# Create wrapper functions
for cmd in python{,3} conda pip{,3}; do
  eval "$cmd() { _load_conda; $cmd \"\$@\"; }"
done

for cmd in node npm npx nvm; do
  eval "$cmd() { _load_nvm; $cmd \"\$@\"; }"
done

dopy() { _load_conda; }
donode() { _load_nvm; }
donp() { _load_conda; _load_nvm; }

# ===================================================================
# TOOL INITIALIZATIONS - Conditional and cached
# ===================================================================

# FZF - check once
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
(( $+commands[fzf] )) && eval "$(fzf --zsh)"

# Zoxide - check once
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# Starship - check once
(( $+commands[starship] )) && eval "$(starship init zsh)"

# Bun
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# rbenv - lazy with rehash disabled
if [[ -s "$HOME/.rbenv/bin/rbenv" ]]; then
  eval "$(~/.rbenv/bin/rbenv init - --no-rehash zsh)"
  [[ -s "$HOME/.rbenv/completions" ]] && fpath=("$HOME/.rbenv/completions" $fpath)
fi

# ===================================================================
# FUNCTIONS - Optimized
# ===================================================================

newgo() {
  [[ $# -eq 0 ]] && { echo "Usage: newgo <module_name>"; return 1; }
  local m="$1"
  mkdir -p "$m" && cd "$m" && go mod init "$m" && \
  printf '%s\n' "package main" '' "import \"fmt\"" '' "func main() {" "    fmt.Println(\"Hello, $m!\")" "}" > main.go && \
  echo "New Go module '$m' created"
}

newleetpy() {
  [[ $# -lt 2 ]] && { echo "Usage: newleetpy <problem_number> <problem_url>"; return 1; }
  local dir="${1}-$(awk -F'/' '{print $5}' <<< "$2")"
  mkdir -p "$dir" && cat > "$dir/main.py" <<'EOF' && cd "$dir"
class Solution:
    def solve(self):
        pass

if __name__ == "__main__":
    s = Solution()
    print(s.solve())
EOF
}

newleet() {
  [[ $# -lt 2 ]] && { echo "Usage: newleet <problem_number> <problem_url>"; return 1; }
  local dir="${1}-$(awk -F'/' '{print $5}' <<< "$2")"
  mkdir -p "$dir" && cat > "$dir/main.cpp" <<'EOF' && cd "$dir"
#include <vector>
#include <string>
#include <logger.h>
#include <dwlc.h>

using namespace std;

auto &l = Logger::get();

int main() {
  l.INFO(Solution());
}
EOF
}

doese() {
  export PATH="/home/daniel/development/11dbpg/bin:$PATH"
  export LD_LIBRARY_PATH="/home/daniel/development/11dbpg/lib:$LD_LIBRARY_PATH"
  alias pgstart="11db_ctl -D /home/daniel/development/datadir/ese1/ -l /home/daniel/development/datadir/ese1/logfile start"
  alias pgrestart="11db_ctl -D /home/daniel/development/datadir/ese1/ -l /home/daniel/development/datadir/ese1/logfile restart"
  alias pgstop="11db_ctl -D /home/daniel/development/datadir/ese1/ -l /home/daniel/development/datadir/ese1/logfile stop"
}

dopg() {
  export PATH="/home/daniel/development/pg/bin:$PATH"
  export LD_LIBRARY_PATH="/home/daniel/development/pg/lib:$LD_LIBRARY_PATH"
  alias pgstart="pg_ctl -D /home/daniel/development/datadir/data1/ -l /home/daniel/development/datadir/data1/logfile start"
  alias pgrestart="pg_ctl -D /home/daniel/development/datadir/data1/ -l /home/daniel/development/datadir/data1/logfile restart"
  alias pgstop="pg_ctl -D /home/daniel/development/datadir/data1/ -l /home/daniel/development/datadir/data1/logfile stop"
}

t() { tmux has-session -t main 2>/dev/null && tmux a -t main || tmux new-session -s main; }

# ===================================================================
# AUTO-INSTALL - Background, detached, one-shot only
# ===================================================================

_bg_install() {
  local lockfile="$HOME/.zsh_install_lock"
  [[ -f $lockfile ]] && return
  
  {
    touch "$lockfile"
    
    [[ ! -f "$HOME/.local/bin/lazydocker" ]] && \
      curl -sS https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash &>/dev/null

    [[ ! -f /usr/local/bin/lazygit ]] && {
      local v=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
      curl -sLo /tmp/lg.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${v}_Linux_x86_64.tar.gz"
      tar xf /tmp/lg.tar.gz -C /tmp lazygit && sudo install /tmp/lazygit /usr/local/bin
      rm -f /tmp/lg.tar.gz /tmp/lazygit
    } &>/dev/null

    [[ ! -f /usr/local/go/bin/go ]] && {
      local v=$(curl -s "https://go.dev/VERSION?m=text" | awk 'NR==1 {sub(/^go/, ""); print}')
      wget -qO /tmp/go.tar.gz "https://go.dev/dl/go${v}.linux-amd64.tar.gz"
      sudo tar -C /usr/local -xzf /tmp/go.tar.gz && rm /tmp/go.tar.gz
    } &>/dev/null

    [[ ! -f "$HOME/miniconda3/bin/conda" ]] && {
      wget -qO /tmp/mc.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
      bash /tmp/mc.sh -b && rm /tmp/mc.sh
    } &>/dev/null

    [[ ! -f "$NVM_DIR/nvm.sh" ]] && {
      local v=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
      curl -so- "https://raw.githubusercontent.com/nvm-sh/nvm/v${v}/install.sh" | bash
    } &>/dev/null

    [[ ! -f /usr/bin/delta ]] && {
      local v=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
      wget -qO /tmp/delta.deb "https://github.com/dandavison/delta/releases/download/${v}/git-delta_${v}_amd64.deb"
      sudo dpkg -i /tmp/delta.deb && rm /tmp/delta.deb
    } &>/dev/null

    [[ ! -d "$HOME/.fzf" ]] && \
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all &>/dev/null

    [[ ! -f "$HOME/.local/bin/zoxide" ]] && \
      curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh &>/dev/null

    [[ ! -f ~/.gitconfig ]] && cat > ~/.gitconfig <<'EOF'
[user]
	email = danielwiratman@gmail.com
	name = Daniel Wiratman
[core]
  longpaths = true
  pager = delta
[interactive]
  diffFilter = delta --color-only
[delta]
  navigate = true
  line-numbers = true
[merge]
  conflictstyle = diff3
[diff]
  colorMoved = default
[credential]
	helper = store
[pull]
  rebase = false
EOF

    [[ ! -f ~/secrets.sh ]] && cat > ~/secrets.sh <<'EOF'
export OPENAI_API_KEY=

alias conndo=""
alias connss=""
EOF

    rm -f "$lockfile"
  } &|
}

# Only run if tools missing
[[ ! -f "$HOME/.local/bin/lazydocker" || ! -f /usr/local/bin/lazygit || \
   ! -f /usr/local/go/bin/go || ! -f "$HOME/miniconda3/bin/conda" || \
   ! -f "$NVM_DIR/nvm.sh" || ! -f /usr/bin/delta || \
   ! -d "$HOME/.fzf" || ! -f "$HOME/.local/bin/zoxide" ]] && _bg_install

# ===================================================================
# COMPLETIONS - Cached and optimized
# ===================================================================

# Cache completions for 20 hours
autoload -Uz compinit
setopt EXTENDEDGLOB
for dump in $HOME/.zcompdump(#qN.mh+20); do
  compinit
  touch $HOME/.zcompdump
done
compinit -C
unsetopt EXTENDEDGLOB

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ===================================================================
# LOAD SECRETS
# ===================================================================

[[ -f ~/secrets.sh ]] && source ~/secrets.sh
