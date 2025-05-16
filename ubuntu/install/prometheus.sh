#!/bin/bash

# variable settings 
PROM_VERSION="3.3.1"
USER="prometheus"
GROUP="prometheus"
INSTALL_DIR="/opt/prometheus"
CONFIG_DIR="/etc/prometheus"
DATA_DIR="/var/lib/prometheus"

echo -e "Версия Prometheus: $PROM_VERSION\n\
         Пользователь: $USER\n\
         Группа: $GROUP\n\
         Директория установки: $INSTALL_DIR\n\
         Директория конфигурации: $CONFIG_DIR\n\
         Директория данных: $DATA_DIR"

# Download and unpack
echo "Download and unpack..."
cd /tmp || { echo "Failed move to /tmp"; exit 1; }
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz
tar -xzf prometheus-${PROM_VERSION}.linux-amd64.tar.gz
sudo mv prometheus-${PROM_VERSION}.linux-amd64 ${INSTALL_DIR}
echo "Done"

# Creating a user
echo -e "Creating a user $USER"
if ! id "$USER" &>/dev/null; then
  sudo useradd --no-create-home --shell /usr/sbin/nologin "$USER"
  echo "✅ User '$USER' created."
else
  echo "ℹ️ User '$USER' already exist, skip."
fi

# Granting user rights to directories
echo -e "Granting user rights to directories: ($INSTALL_DIR, $CONFIG_DIR, $DATA_DIR)"
sudo mkdir -p $CONFIG_DIR $DATA_DIR
sudo cp ${INSTALL_DIR}/prometheus.yml $CONFIG_DIR
sudo chown -R $USER:$GROUP $INSTALL_DIR $CONFIG_DIR $DATA_DIR
echo "Done"

# Installing binaries
echo "Installing binaries"
sudo cp ${INSTALL_DIR}/prometheus /usr/local/bin/
sudo cp ${INSTALL_DIR}/promtool /usr/local/bin/
sudo chown $USER:$GROUP /usr/local/bin/prometheus /usr/local/bin/promtool
echo "Done"

# systemd unit file
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=$USER
Group=$GROUP
Type=simple
ExecStart=/usr/local/bin/prometheus \\
  --config.file=$CONFIG_DIR/prometheus.yml \\
  --storage.tsdb.path=$DATA_DIR

[Install]
WantedBy=multi-user.target
EOF

# start
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus

echo "✅ Prometheus installed and started: http://localhost:9090"
