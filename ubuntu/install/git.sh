#!/bin/bash

set -e

echo "🔧 Installing Git..."

# Update package list
sudo apt-get update

# Install Git
sudo apt-get install -y git

# Verify installation
GIT_VERSION=$(git --version)
echo "✅ $GIT_VERSION installed successfully!"

# Optional: Set up basic git configuration
echo ""
echo "To configure Git, run:"
echo "  git config --global user.name \"Your Name\""
echo "  git config --global user.email \"your.email@example.com\""
