#!/bin/bash

set -e

echo "🔧 Installing Nginx..."

# Update package list
sudo apt-get update

# Install Nginx
sudo apt-get install -y nginx

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Verify installation
NGINX_VERSION=$(nginx -v 2>&1)
echo "✅ $NGINX_VERSION installed successfully!"

# Show status
sudo systemctl status nginx --no-pager | head -n 5

echo ""
echo "Nginx is running on http://localhost:80"
echo "Configuration files: /etc/nginx/"
echo "Default web root: /var/www/html/"
