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