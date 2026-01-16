#!/bin/bash

set -e

echo "🧹 Removing Nginx..."

# Stop Nginx service
if systemctl is-active --quiet nginx; then
    sudo systemctl stop nginx
fi

# Disable service
sudo systemctl disable nginx || true

# Remove Nginx packages
sudo apt-get remove -y nginx nginx-common nginx-full

# Remove unused dependencies
sudo apt-get autoremove -y

echo "✅ Nginx removed."
echo ""
echo "Note: Configuration files in /etc/nginx/ and web files in /var/www/ are preserved."
echo "To remove them completely, run:"
echo "  sudo rm -rf /etc/nginx/"
echo "  sudo rm -rf /var/www/"
