FROM debian:11

RUN apt-get update

RUN apt-get install -y sudo openssh-server git curl wget

RUN echo 'root:123123' | chpasswd

RUN useradd -m -s /bin/bash user1 && \
  echo 'user1:123123' | chpasswd && \
  usermod -aG sudo user1

RUN mkdir /var/run/sshd && \
  echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
  echo 'Port 2222' >> /etc/ssh/sshd_config

WORKDIR /home/user1

RUN LATEST_GO_VERSION=$(curl -s "https://go.dev/VERSION?m=text" | awk 'NR==1 {sub(/^go/, "", $1); print $1}') && \
  wget https://go.dev/dl/go${LATEST_GO_VERSION}.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf go${LATEST_GO_VERSION}.linux-amd64.tar.gz && \
  rm go${LATEST_GO_VERSION}.linux-amd64.tar.gz && \
  echo 'export PATH=$PATH:/usr/local/go/bin' >> .bashrc

USER user1

RUN LATEST_NVM_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${LATEST_NVM_VERSION}/install.sh | bash && \
  export NVM_DIR="$HOME/.nvm" && \
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
  nvm install --lts && \
  nvm use --lts && \
  npm install -g yarn

USER root

RUN apt-get install -y vim nano pkg-config build-essential dumb-init iproute2 iputils-ping net-tools

# ENTRYPOINT ["/usr/bin/dumb-init", "--"]
# CMD ["bash", "-c", "/usr/sbin/sshd -D"]

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["bash"]
