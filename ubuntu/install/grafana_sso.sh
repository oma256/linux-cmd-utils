#!/bin/bash

set -e  # Stop on error

# === Settings ===
GRAFANA_VERSION="12.0.0"
PROMETHEUS_URL="http://localhost:9090"

GRAFANA_ADMIN_USER="admin"
GRAFANA_ADMIN_PASSWORD="supersecret"

# === Installing dependencies ===
echo "🔧 Installing dependencies..."
sudo apt-get update
sudo apt-get install -y apt-transport-https software-properties-common wget gnupg adduser libfontconfig1 musl

# === Adding a Grafana Repository ===
echo "📥 Adding a Grafana Repository..."
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt-get update

# === Download and install .deb ===
echo "📦 Installing Grafana ${GRAFANA_VERSION}..."
wget -q https://dl.grafana.com/oss/release/grafana_${GRAFANA_VERSION}_amd64.deb
sudo dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb

# === Creating a Prometheus Data Source ===
echo "⚙️ Creating a Prometheus Data Source..."
sudo mkdir -p /etc/grafana/provisioning/datasources

cat <<EOF | sudo tee /etc/grafana/provisioning/datasources/prometheus.yaml > /dev/null
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: ${PROMETHEUS_URL}
    isDefault: true
EOF

# === Administrator Settings ===
echo "🔐 Setting up Grafana Admin..."
echo "GF_SECURITY_ADMIN_USER=${GRAFANA_ADMIN_USER}" | sudo tee -a /etc/default/grafana-server
echo "GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}" | sudo tee -a /etc/default/grafana-server

# === Start Grafana ===
echo "🚀 Start and enable Grafana..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now grafana-server

# === check status Grafana ===
echo "✅ Grafana установлена. Интерфейс: http://localhost:3000"
sudo systemctl status grafana-server --no-pager
