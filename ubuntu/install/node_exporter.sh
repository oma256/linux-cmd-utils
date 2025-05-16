#!/bin/bash

set -e

# Настройки
NODE_EXPORTER_VERSION="1.9.0"
NODE_EXPORTER_USER="node_exporter"
INSTALL_DIR="/opt/node_exporter"
BIN_PATH="/usr/local/bin/node_exporter"
SERVICE_PATH="/etc/systemd/system/node_exporter.service"

echo "🔧 Install Node Exporter v$NODE_EXPORTER_VERSION..."

# Create user
if ! id "$NODE_EXPORTER_USER" &>/dev/null; then
    sudo useradd --no-create-home --shell /usr/sbin/nologin "$NODE_EXPORTER_USER"
    echo "✅ User created: $NODE_EXPORTER_USER"
fi

# Download and unpack
cd /tmp
wget -q https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xzf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

# Install
sudo mkdir -p "$INSTALL_DIR"
sudo cp -r node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/* "$INSTALL_DIR"
sudo cp "$INSTALL_DIR/node_exporter" "$BIN_PATH"
sudo chown -R "$NODE_EXPORTER_USER":"$NODE_EXPORTER_USER" "$INSTALL_DIR"
sudo chown "$NODE_EXPORTER_USER":"$NODE_EXPORTER_USER" "$BIN_PATH"

# systemd unit
cat <<EOF | sudo tee "$SERVICE_PATH"
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=$NODE_EXPORTER_USER
Group=$NODE_EXPORTER_USER
Type=simple
ExecStart=$BIN_PATH

[Install]
WantedBy=multi-user.target
EOF

# Запуск
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter

echo "✅ Node Exporter installed and started!"
