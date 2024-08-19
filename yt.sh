#!/bin/bash

if ! command -v yt-dlp &>/dev/null; then
  echo "yt-dlp is not installed. Please install it before running this script."
  exit 1
fi

# Prompt for download type
echo "Select download type:"
echo "1) Video"
echo "2) Audio"
read -p "Enter your choice (default: 1): " download_type
download_type=${download_type:-1}

# Set yt-dlp options based on download type
if [ "$download_type" -eq 2 ]; then
  options="-x --audio-format mp3"
else
  options=""
fi

# Collect URLs
urls=()
echo "Enter URLs (one per line). Press Enter on a blank line to finish:"
while IFS= read -r url; do
  [[ -z "$url" ]] && break
  urls+=("$url")
done

# Download URLs in parallel
echo "Starting downloads..."
for url in "${urls[@]}"; do
  yt-dlp $options "$url" &
done

# Wait for all background jobs to finish
wait
echo "All downloads completed."
