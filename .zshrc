# Disable compfix (saves ~100ms)
ZSH_DISABLE_COMPFIX=true

# ===================================================================
# ENVIRONMENT VARIABLES
# ===================================================================

export ANDROID_HOME="$HOME/Android/Sdk"
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
export BUN_INSTALL="$HOME/.bun"
export NVM_DIR="$HOME/.nvm"
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"
export LD_LIBRARY_PATH="/usr/local/lib"
export GEMINI_MODEL="gemini-2.5-flash"
export TERM="xterm-256color"

# ===================================================================
# PATH - neatly grouped
# ===================================================================

export PATH="\
$HOME/.local/bin:\
$HOME/go/bin:\
$HOME/.rbenv/bin:\
$ANDROID_HOME/platform-tools:\
$ANDROID_HOME/emulator:\
$ANDROID_HOME/cmdline-tools:\
$JAVA_HOME/bin:\
$BUN_INSTALL/bin:\
/opt/nvim:\
/opt/resolve:\
/opt/scrcpy:\
/opt/gradle/gradle-8.10.2/bin:\
/opt/binsider-0.1.0/bin:\
/opt/apache-maven-3.9.9/bin:\
/usr/local/go/bin:\
/usr/bin/android-studio/bin:\
$HOME/development/flutter/bin:\
$HOME/.yarn/bin:\
$PATH"

# ===================================================================
# HISTORY
# ===================================================================

HISTSIZE=50000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=50000

setopt APPEND_HISTORY \
       SHARE_HISTORY \
       HIST_IGNORE_SPACE \
       HIST_IGNORE_ALL_DUPS \
       HIST_SAVE_NO_DUPS \
       HIST_FIND_NO_DUPS

# ===================================================================
# ZINIT (plugin manager)
# ===================================================================

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ ! -d $ZINIT_HOME ]] && mkdir -p "$(dirname $ZINIT_HOME)" \
  && git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "$ZINIT_HOME/zinit.zsh"

# Core plugins (async load after prompt)
zinit wait lucid for \
  OMZP::git \
  OMZP::sudo \
  OMZP::command-not-found

# UI & completions
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
# TOOLS INITIALIZATION
# ===================================================================

# FZF
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
(( $+commands[fzf] )) && eval "$(fzf --zsh)"

# Zoxide
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# Starship prompt
(( $+commands[starship] )) && eval "$(starship init zsh)"

# Bun
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# rbenv
if [[ -s "$HOME/.rbenv/bin/rbenv" ]]; then
  eval "$(~/.rbenv/bin/rbenv init - --no-rehash zsh)"
  [[ -s "$HOME/.rbenv/completions" ]] && fpath=("$HOME/.rbenv/completions" $fpath)
fi

# Conda (eager load)
if [[ -f "$HOME/miniconda3/bin/conda" ]]; then
  __conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2>/dev/null)"
  [[ $? -eq 0 ]] && eval "$__conda_setup" || {
    [[ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]] \
      && . "$HOME/miniconda3/etc/profile.d/conda.sh" \
      || export PATH="$HOME/miniconda3/bin:$PATH"
  }
  unset __conda_setup
fi

# NVM (eager load)
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh" --no-use
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
nvm use --lts >/dev/null 2>&1

# ===================================================================
# FUNCTIONS
# ===================================================================

# New Go project
newgo() {
  [[ $# -eq 0 ]] && { echo "Usage: newgo <module_name>"; return 1; }
  local m="$1"
  mkdir -p "$m" && cd "$m" \
    && go mod init "$m" \
    && printf '%s\n' "package main" "" "import \"fmt\"" "" \
       "func main() {" "    fmt.Println(\"Hello, $m!\")" "}" > main.go \
    && echo "New Go module '$m' created"
}

# New LeetCode Python project
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

# New LeetCode C++ project
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

# Tmux main session
t() {
  tmux has-session -t main 2>/dev/null \
    && tmux a -t main \
    || tmux new-session -s main
}

# ===================================================================
# COMPLETIONS
# ===================================================================

autoload -Uz compinit
setopt EXTENDEDGLOB

# Cache completions for 20h
for dump in $HOME/.zcompdump(#qN.mh+20); do
  compinit
  touch $HOME/.zcompdump
done
compinit -C
unsetopt EXTENDEDGLOB

# Completion styles
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# fzf-tab previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ===================================================================
# LOAD SECRETS
# ===================================================================

[[ -f ~/secrets.sh ]] && source ~/secrets.sh

