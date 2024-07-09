#!/bin/bash

TARGET_DIR="$HOME"

if [ -f ".stow-local-ignore" ]; then
  mkdir -p "$TARGET_DIR/.config/stow"
  cp .stow-local-ignore "$TARGET_DIR/.config/stow/.stow-local-ignore"
fi

stow -v -t "$TARGET_DIR" .

echo "Install completed."
