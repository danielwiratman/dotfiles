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
      my_tmux a -t main
  else
      my_tmux new-session -s main
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