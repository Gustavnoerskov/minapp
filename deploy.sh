#!/bin/bash
# Auto-deploy MinApp to GitHub Pages
# Called by Claude Code hook after file edits

INPUT=$(cat)
if ! echo "$INPUT" | grep -q "MinApp.html"; then
  exit 0
fi

SOURCE=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4)
if [[ "$SOURCE" != *"MinApp.html"* ]]; then
  exit 0
fi

# Find minapp repo (works on any machine if minapp is sibling of Claude folder)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="$SCRIPT_DIR/index.html"
CLAUDE_DIR="$(dirname "$SCRIPT_DIR")/Claude/projekter/WebbaseretApp/MinApp.html"

if [ ! -f "$CLAUDE_DIR" ]; then
  exit 0
fi

cp "$CLAUDE_DIR" "$DEST"
cd "$SCRIPT_DIR"

STATUS=$(git status --porcelain)
if [ -n "$STATUS" ]; then
  git add index.html
  git commit -m "Auto-deploy: update app"
  git push
fi
