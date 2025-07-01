# Path and environment variable exports

# Basic paths
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/go/bin
export PATH=$PATH:/opt/nvim
export PATH=$PATH:/opt/resolve/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/development/flutter/bin
export PATH=$PATH:/usr/bin/android-studio/bin

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
# export FZF_DEFAULT_COMMAND='rg --hidden -l ""'
export TERM=xterm-256color

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"