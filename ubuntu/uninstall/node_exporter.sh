#!/bin/bash

set -e

# Settings
NODE_EXPORTER_USER="node_exporter"
INSTALL_DIR="/opt/node_exporter"
BIN_PATH="/usr/local/bin/node_exporter"
SERVICE_PATH="/etc/systemd/system/node_exporter.service"

echo "🧹 Remove Node Exporter..."

# Stop and disable service
if systemctl is-active --quiet node_exporter; then
    sudo systemctl stop node_exporter
fi

sudo systemctl disable node_exporter || true
sudo rm -f "$SERVICE_PATH"

# Remove binary files and data
sudo rm -f "$BIN_PATH"
sudo rm -rf "$INSTALL_DIR"

# Remove 
if id "$NODE_EXPORTER_USER" &>/dev/null; then
    sudo userdel "$NODE_EXPORTER_USER"
fi

# Restart systemd
sudo systemctl daemon-reload

echo "✅ Node Exporter removed."
