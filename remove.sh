#!/bin/bash

# Remove platform-specific folders
rm -rf android ios linux macos web windows

# Remove the test folder (optional, if you aren't using it yet)
rm -rf test

# Remove IDE settings and generated files
rm -rf .idea
rm -f *.iml
rm -rf pubspec.lock
rm -rf analysis_options.yaml
rm -rf .metadata
rm -rf .dart_tool
rm -rf build
rm -rf .flutter-plugins-dependencies

echo "Cleaned up 🧹!"