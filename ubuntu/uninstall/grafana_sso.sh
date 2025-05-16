#!/bin/bash

set -e

echo "🗑️ Stop and disable Grafana..."
sudo systemctl stop grafana-server || true
sudo systemctl disable grafana-server || true

echo "🧽 Remove systemd unit..."
sudo rm -f /etc/systemd/system/grafana-server.service
sudo systemctl daemon-reload

echo "📦 Remove package Grafana..."
sudo dpkg --purge grafana || true

echo "🧹 Removing configuration and data..."
sudo rm -rf /etc/grafana
sudo rm -rf /var/lib/grafana
sudo rm -rf /var/log/grafana
sudo rm -rf /usr/share/grafana

echo "🔐 Removing Environment Variables..."
sudo sed -i '/GF_SECURITY_ADMIN_USER/d' /etc/default/grafana-server || true
sudo sed -i '/GF_SECURITY_ADMIN_PASSWORD/d' /etc/default/grafana-server || true

echo "📜 У
