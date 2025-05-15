#!/bin/bash

USER="prometheus"
GROUP="prometheus"
INSTALL_DIR="/opt/prometheus"
CONFIG_DIR="/etc/prometheus"
DATA_DIR="/var/lib/prometheus"
SERVICE_FILE="/etc/systemd/system/prometheus.service"
BINARIES=("/usr/local/bin/prometheus" "/usr/local/bin/promtool")

echo "🧹 Stop and disable the Prometheus service..."
sudo systemctl stop prometheus
sudo systemctl disable prometheus

echo "Remove the systemd service and reboot the daemon..."
sudo rm -f "$SERVICE_FILE"
sudo systemctl daemon-reload

echo "🧹 Delete Prometheus user and group..."
sudo userdel -r "$USER" 2>/dev/null || echo "Пользователь $USER не найден"
sudo groupdel "$GROUP" 2>/dev/null || echo "Группа $GROUP не найдена"

echo "🧹 Удаляем каталоги Prometheus..."
sudo rm -rf "$INSTALL_DIR" "$CONFIG_DIR" "$DATA_DIR"

echo "🧹 Removing Prometheus directories..."
for bin in "${BINARIES[@]}"; do
  sudo rm -f "$bin"
done

echo "✅ Prometheus removal completed."
