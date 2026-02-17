#!/bin/bash
export PATH="$PATH:$HOME/development/flutter/bin"

# 1. Regenerate platform folders
flutter create .

# 2. Get dependencies
flutter pub get

echo "Setup complete! 🚀"