# Terminal appearance settings

# Set terminal opacity for st terminal
if [[ $(cat /proc/$PPID/comm) = "st" ]]; then
  opa 9
fi

# Bun completion
[ -s "/home/daniel/.bun/_bun" ] && source "/home/daniel/.bun/_bun"