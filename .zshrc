# Auto-installations of tools

# Install lazydocker if not present
if [ ! -f "$HOME/.local/bin/lazydocker" ]; then
  echo "Installing lazydocker..."
  curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

# Install lazygit if not present
if [ ! -f /usr/local/bin/lazygit ]; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm -rf lazygit.tar.gz lazygit
fi

# Install Go if not present
if [ ! -f /usr/local/go/bin/go ]; then
  echo "Installing go..."
  LATEST_GO_VERSION=$(curl -s "https://go.dev/VERSION?m=text" | awk 'NR==1 {sub(/^go/, "", $1); print $1}')
  wget https://go.dev/dl/go${LATEST_GO_VERSION}.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go${LATEST_GO_VERSION}.linux-amd64.tar.gz
  rm go${LATEST_GO_VERSION}.linux-amd64.tar.gz
fi

# Install Miniconda if not present
if [ ! -f "$HOME/miniconda3/bin/conda" ]; then
  echo "Installing conda..."
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  bash Miniconda3-latest-Linux-x86_64.sh
  rm Miniconda3-latest-Linux-x86_64.sh
fi

# Install NVM if not present
export NVM_DIR="$HOME/.nvm"
if [ ! -f "$NVM_DIR/nvm.sh" ]; then
  echo "Installing nvm..."
  LATEST_NVM_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${LATEST_NVM_VERSION}/install.sh | bash
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm use --lts
fi


# Install git-delta if not present
if [ ! -f /usr/bin/delta ]; then
  echo "Installing git-delta..."
  LATEST_GIT_DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
  wget https://github.com/dandavison/delta/releases/download/${LATEST_GIT_DELTA_VERSION}/git-delta_${LATEST_GIT_DELTA_VERSION}_amd64.deb
  sudo dpkg -i git-delta_${LATEST_GIT_DELTA_VERSION}_amd64.deb
  rm git-delta_${LATEST_GIT_DELTA_VERSION}_amd64.deb
fi


# Install fzf if not present
if [ ! -f "$HOME/.fzf/bin/fzf" ]; then
  echo "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

# Install zoxide if not present
if [ ! -f "$HOME/.local/bin/zoxide" ]; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# Create .gitconfig if not present
if [ ! -f ~/.gitconfig ]; then
  echo "Creating .gitconfig..."
  touch ~/.gitconfig
  echo "[user]
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
  rebase = false" > ~/.gitconfig
fi

# Create secrets.sh if not present
if [ ! -f ~/secrets.sh ]; then
  echo "Creating secrets.sh..."
  touch ~/secrets.sh
  echo "export OPENAI_API_KEY=

alias conndo=\"\"
alias connss=\"\"" > ~/secrets.sh
fi

alias ls="ls --color"
alias l="ls -ltrah"
alias lg="lazygit"
alias ldo="lazydocker"
alias py="python"
alias n="nvim ."
alias mmi="make && make install"
alias mcmu="make clean && make uninstall"
alias mcmummi="make clean && make uninstall && make && make install"
alias bm="bear -- make"
alias bmmi="bear -- make && make install"
alias zconfig="nvim ~/.zshrc && source ~/.zshrc"
alias secconfig="vim ~/secrets.sh && source ~/secrets.sh"
alias tconfig="cd ~/.config/tmux && vim tmux.conf"
alias kittyconfig="cd ~/.config/kitty && vim kitty.conf"
alias nvimconfig="cd ~/.config/nvim && nvim ."
alias chat="sgpt --repl temp"
alias rm="trash"

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^H' backward-kill-word
bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

set clipboard+=unnamedplus

# Zinit plugin manager configuration

# Load zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

zinit cdreplay -q

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(fzf --zsh)"

if [[ $(which zi 2>/dev/null) && $(alias zi) ]]; then unalias zi; fi

eval "$(zoxide init zsh)"

eval "$(starship init zsh)"

# Basic paths
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/go/bin
export PATH=$PATH:/opt/nvim
export PATH=$PATH:/opt/resolve/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/development/flutter/bin
export PATH=$PATH:/usr/bin/android-studio/bin
export PATH=$PATH:~/.yarn/bin

# Android SDK paths
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/cmdline-tools

# Java paths
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:/opt/gradle/gradle-8.10.2/bin
export PATH=$PATH:/opt/binsider-0.1.0
export PATH=$PATH:/opt/apache-maven-3.9.9/bin

# Other tools
export PATH=$PATH:/opt/doxygen-1.13.2/bin
export PATH=$PATH:/opt/scrcpy

# Application settings
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
export LD_LIBRARY_PATH=/usr/local/lib
export GEMINI_MODEL="gemini-2.5-flash"
export TERM=xterm-256color

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

newgo() {
	if [ $# -eq 0 ]; then
		echo "Usage: newgo <module_name>"
		return 1
	fi
	local module_name="$1"
	mkdir -p "$module_name" &&
		cd "$module_name" &&
		go mod init "$module_name" &&
		printf '%s\n' "package main" '' "import \"fmt\"" '' "func main() {" "    fmt.Println(\"Hello, $module_name!\")" "}" >main.go
	echo "New Go module '$module_name' created with main.go"
}

newleetpy() {
  if [ $# -eq 0 ]; then
    echo "Usage: newleetpy <problem_number> <problem_url>"
    return 1
  fi

  local problem_number=$1
  local problem_url=$2

  problem_title=$(echo "$problem_url" | awk -F'/' '{print $5}')

  dir_name="${problem_number}-${problem_title}"
  mkdir -p "$dir_name"

  cat <<EOL >"$dir_name/main.py"
class Solution:
    def solve(self):
        pass


if __name__ == "__main__":
    s = Solution()
    print(s.solve())
EOL

  cd "$dir_name"
}

newleet() {
  if [ $# -eq 0 ]; then
    echo "Usage: newleet <problem_number> <problem_url>"
    return 1
  fi

  local problem_number=$1
  local problem_url=$2

  problem_title=$(echo "$problem_url" | awk -F'/' '{print $5}')

  dir_name="${problem_number}-${problem_title}"
  mkdir -p "$dir_name"

  cat <<EOL >"$dir_name/main.cpp"
#include <vector>
#include <string>
#include <logger.h>
#include <dwlc.h>

using namespace std;

auto &l = Logger::get();



int main() {
  l.INFO(Solution());
}
EOL

  cd "$dir_name"
}

doese() {
	export PATH=$PATH:"/home/daniel/development/11dbpg/bin"
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"/home/daniel/development/11dbpg/lib"
	alias pgstart="11db_ctl -D /home/daniel/development/datadir/ese1/ -l /home/daniel/development/datadir/ese1/logfile start"
	alias pgrestart="11db_ctl -D /home/daniel/development/datadir/ese1/ -l /home/daniel/development/datadir/ese1/logfile restart"
	alias pgstop="11db_ctl -D /home/daniel/development/datadir/ese1/ -l /home/daniel/development/datadir/ese1/logfile stop"
}

dopg() {
	export PATH=$PATH:"/home/daniel/development/pg/bin"
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"/home/daniel/development/pg/lib"
	alias pgstart="pg_ctl -D /home/daniel/development/datadir/data1/ -l /home/daniel/development/datadir/data1/logfile start"
	alias pgrestart="pg_ctl -D /home/daniel/development/datadir/data1/ -l /home/daniel/development/datadir/data1/logfile restart"
	alias pgstop="pg_ctl -D /home/daniel/development/datadir/data1/ -l /home/daniel/development/datadir/data1/logfile stop"
}

donode() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

dopy() {
  __conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
          . "$HOME/miniconda3/etc/profile.d/conda.sh"
      else
          export PATH="$HOME/miniconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
}

donp() {
  donode
  dopy
}

t() {
  if tmux has-session -t main 2>/dev/null; then
      tmux a -t main
  else
      tmux new-session -s main
  fi
}


[ -s "/home/daniel/.bun/_bun" ] && source "/home/daniel/.bun/_bun"

[ -s "/etc/profile.d/rvm.sh" ] && source "/etc/profile.d/rvm.sh"

donp

. ~/secrets.sh
