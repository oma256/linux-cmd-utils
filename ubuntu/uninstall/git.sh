#!/bin/bash

set -e

echo "🧹 Removing Git..."

# Remove Git package
sudo apt-get remove -y git

# Remove unused dependencies
sudo apt-get autoremove -y

echo "✅ Git removed."
echo ""
echo "Note: Git configuration files in ~/.gitconfig are preserved."
echo "To remove them manually, run: rm ~/.gitconfig"
