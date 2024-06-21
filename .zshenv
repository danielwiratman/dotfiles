if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  export _JAVA_AWT_WM_NONREPARENTING=1
  export AWT_TOOLKIT=MToolkit
  if [[ -f /usr/bin/wmname ]]; then
    wmname LG3D
  fi
  exec startx
fi
