#!/bin/bash

# Error handling: Check if an argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <article-title>"
  exit 1
fi

# Replace spaces in the argument with hyphens
title=$(echo "$1" | tr ' ' '-')

# Generate folder name using the current date and the title
foldername="posts/$(date +%y%m%d)-${title}"

# Create the folder and a new Hugo post file inside it
hugo new "${foldername}/index.md"

# Check if the operation was successful
if [ $? -eq 0 ]; then
  echo "Post folder and file created: $foldername"
else
  echo "Failed to create post folder."
  exit 1
fi
