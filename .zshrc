if [[ "$ZPROF" = true ]]; then
  zmodload zsh/zprof
fi

# Installs
if [ ! -f "$HOME/.local/bin/lazydocker" ]; then
  echo "Installing lazydocker..."
  curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

if [ ! -f /usr/local/bin/lazygit ]; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm -rf lazygit.tar.gz lazygit
fi

if [ ! -f /usr/local/go/bin/go ]; then
  echo "Installing go..."
  LATEST_GO_VERSION=$(curl -s "https://go.dev/VERSION?m=text" | awk 'NR==1 {sub(/^go/, "", $1); print $1}')
  wget https://go.dev/dl/go${LATEST_GO_VERSION}.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go${LATEST_GO_VERSION}.linux-amd64.tar.gz
  rm go${LATEST_GO_VERSION}.linux-amd64.tar.gz
fi

if [ ! -f "$HOME/miniconda3/bin/conda" ]; then
  echo "Installing conda..."
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  bash Miniconda3-latest-Linux-x86_64.sh
  rm Miniconda3-latest-Linux-x86_64.sh
fi

if [ ! -f "$HOME/.nvm/nvm.sh" ]; then
  echo "Installing nvm..."
  LATEST_NVM_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${LATEST_NVM_VERSION}/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  nvm install --lts
  nvm use --lts
fi

if [ ! -f /usr/bin/nvim ]; then
  echo "Installing nvim..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  sudo mv nvim.appimage /usr/bin/nvim
fi

if [ ! -f /usr/bin/delta ]; then
  echo "Installing git-delta..."
  LATEST_GIT_DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
  wget https://github.com/dandavison/delta/releases/download/${LATEST_GIT_DELTA_VERSION}/git-delta_${LATEST_GIT_DELTA_VERSION}_amd64.deb
  sudo dpkg -i git-delta_${LATEST_GIT_DELTA_VERSION}_amd64.deb
  rm git-delta_${LATEST_GIT_DELTA_VERSION}_amd64.deb
fi

if [ ! -f "$HOME/.yazi/LICENSE" ]; then
  echo "Installing yazi..."
  wget https://github.com/sxyazi/yazi/releases/download/v0.2.5/yazi-x86_64-unknown-linux-gnu.zip
  unzip yazi-x86_64-unknown-linux-gnu.zip
  mv yazi-x86_64-unknown-linux-gnu .yazi
  sudo mv .yazi/yazi /usr/local/bin
  sudo mv .yazi/ya /usr/local/bin
  rm -rf yazi-x86_64-unknown-linux-gnu.zip
  git clone https://github.com/BennyOe/onedark.yazi.git ~/.config/yazi/flavors/onedark.yazi
  sudo mkdir -p /root/.config
  sudo ln -s "$HOME/.config/yazi/" /root/.config
fi

if [ ! -f "$HOME/.fzf/bin/fzf" ]; then
  echo "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

if [ ! -f "$HOME/.local/bin/zoxide" ]; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

if [ ! -f /usr/local/bin/lazysql ]; then
  echo "Installing lazysql..."
  LATEST_LAZYSQL_VERSION=$(curl -s "https://api.github.com/repos/jorgerojas26/lazysql/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
  wget https://github.com/jorgerojas26/lazysql/releases/download/${LATEST_LAZYSQL_VERSION}/lazysql_Linux_x86_64.tar.gz
  mkdir lazysql
  tar xvzf lazysql_Linux_x86_64.tar.gz -C lazysql
  sudo mv lazysql/lazysql /usr/local/bin
  rm lazysql_Linux_x86_64.tar.gz
  rm -rf lazysql
fi

# if .gitconfig not exists, create it
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
  colorMoved = default" > ~/.gitconfig
fi

# if secrets.sh not exists, create it
if [ ! -f ~/secrets.sh ]; then
  echo "Creating secrets.sh..."
  touch ~/secrets.sh
  echo "export OPENAI_API_KEY=

alias conndo=""
alias connss=""" > ~/secrets.sh
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Completions
if [ ! -d "$HOME/.docker/completions" ]; then
  echo "Installing docker completions..."
  mkdir -p "$HOME/.docker/completions"
  docker completion zsh > "$HOME/.docker/completions/_docker"
fi
fpath=(~/.docker/completions \\$fpath)
fpath=(~/.yazi/completions \\$fpath)
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# Add in zsh plugins
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load zsh-autosuggestions
zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^H' backward-kill-word
bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# History
HISTSIZE=5000
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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Sets
set clipboard+=unnamedplus

# Exports
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/go/bin
export PATH=$PATH:/opt/nvim
export PATH=$PATH:/opt/resolve/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/bin/flutter/bin
export PATH=$PATH:/usr/bin/android-studio/bin

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/cmdline-tools

export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

export LD_LIBRARY_PATH=/usr/local/lib
# export FZF_DEFAULT_COMMAND='rg --hidden -l ""'
export TERM=xterm-256color

# Aliases
alias scrcpy="scrcpy --max-size 1024 --show-touches --turn-screen-off"

alias ta="tmux a"
alias ts="tmux splitw"
alias tsh="tmux splitw -h"

alias ls="ls --color"
alias l="ls -ltrah"

alias n="nvim"
alias no="cd ~/my-vault && n main.md"
alias nod="cd ~/my-vault && n 01\ Daily\ Notes/$(date +'%Y-%m-%d').md"

alias lg="lazygit"
alias ldo="lazydocker"
alias lsq="lazysql"

alias o="xdg-open"
alias yt="ytfzf"

alias py="python"

alias mmi="make && make install"
alias mcmu="make clean && make uninstall"
alias bm="bear -- make"
alias bmmi="bear -- make && make install"

alias zconfig="n ~/.zshrc && source ~/.zshrc"
alias nconfig="cd ~/.config/nvim && n init.lua"
alias tconfig="cd ~/.config/tmux && n tmux.conf"
alias chatconfig="cd ~/.config/shell_gpt && n .sgptrc"
alias htpv="http -v"
alias rmnswap="rm -rf /home/daniel/.local/state/nvim/swap/*"
alias windows="cd /mnt/c/Users/Daniel"

alias passmenu="passmenu -fn 'MesloLGS NF:size=14'"
alias d="ddgr"
alias wifi="nmtui connect"

# Shell integrations
eval "$(fzf --zsh)"

if [[ $(which zi 2>/dev/null) && $(alias zi) ]]; then unalias zi; fi
eval "$(zoxide init zsh)"

# Functions
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

doese() {
	export PATH=$PATH:"/home/daniel/development/11dbpg/bin"
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"/home/daniel/development/11dbpg/lib"
	alias pgstart="11db_ctl -D /home/daniel/development/datadir/data1/ -l /home/daniel/development/datadir/data1/logfile start"
	alias pgrestart="11db_ctl -D /home/daniel/development/datadir/data1/ -l /home/daniel/development/datadir/data1/logfile restart"
	alias pgstop="11db_ctl -D /home/daniel/development/datadir/data1/ -l /home/daniel/development/datadir/data1/logfile stop"
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

tsw() {
	tmux swap-window -s "$1" -t "$2"
}

update_lazy() {
  nvim --headless '+Lazy! sync' +qa
}

install_docker() {
  echo "Installing docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  rm get-docker.sh
}

removeNvimData() {
  sudo rm -rf ~/.local/share/nvim
  sudo rm -rf ~/.local/state/nvim
}

removeGoData() {
  sudo rm -rf "$HOME/go"
}

removeAllInstalls() {
  sudo rm -rf "$HOME/.local/bin/lazydocker"
  sudo rm -rf /usr/local/bin/lazygit
  sudo rm -rf /usr/local/go
  sudo rm -rf "$HOME/miniconda3"
  sudo rm -rf "$HOME/.nvm"
  sudo rm -rf /usr/bin/nvim
  sudo rm -rf /usr/bin/delta
  sudo rm -rf "$HOME/.fzf"
  sudo rm -rf "$HOME/.local/zoxide"
  sudo rm -rf /usr/local/bin/yazi /usr/local/bin/ya "$HOME/.yazi"

  removeNvimData
  removeGoData
}

y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
zle -N y
bindkey -s '^f' 'y^M'
alias sy="sudo yazi"

timezsh() {
  for i in $(seq 1 10); do time zsh -i -c exit; done
}

profzsh() {
  shell=${1-$SHELL}
  ZPROF=true $shell -i -c exit
}

my_tmux() {
  export TERM=screen-256color
  tmux -u "$@"
  export TERM=xterm-256color
}

t() {
  if tmux has-session -t main 2>/dev/null; then
      my_tmux a -t main
  else
      my_tmux new-session -s main
  fi
}

source ~/secrets.sh

opa() {
    transset-df "0.$1" --id "$WINDOWID" > /dev/null
}

if [[ $(cat /proc/$PPID/comm) = "st" ]]; then
  opa 9
fi

eye() {
  temperature=2000
  if [[ $1 =~ ^[0-9]+$ ]]; then
    temperature=$1
    redshift -x
    redshift -O $temperature
  else
    if [[ -f /tmp/eyesore ]]; then
      redshift -x
      rm /tmp/eyesore
    else
      redshift -O $temperature
      touch /tmp/eyesore
    fi
  fi
}

unzip_auto() {
    unzip -d temp_folder "$1"
    files=(temp_folder/*)
    if [ ${#files[@]} -eq 1 -a -d "${files[0]}" ]; then
        mv temp_folder/*/* .
    else
        mv temp_folder/* .
    fi
    rm -r temp_folder
}

dihis() {
    setopt noincappendhistory
    unset HISTFILE
}

enhis() {
    setopt incappendhistory
    HISTFILE=$HOME/.zsh_history
}

grayscale() {
  $HOME/toggle-monitor-grayscale.sh
  if [[ -f /tmp/grayscale ]]; then
    feh --bg-fill $HOME/.config/ponywall/pwall_composite.jpg
    rm /tmp/grayscale
  else
    feh --bg-fill $HOME/wallpapers/black.jpg
    touch /tmp/grayscale
  fi
}

chat() {
  dopy
  if [ -n "$1" ]; then
    sgpt --repl "$1"
  else
    sgpt --repl temp
  fi
}

if [[ "$ZPROF" = true ]]; then
  zprof
fi

# bun completions
[ -s "/home/daniel/.bun/_bun" ] && source "/home/daniel/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
