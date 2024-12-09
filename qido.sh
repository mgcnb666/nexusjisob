#!/bin/bash

# 更新和升级系统
sudo apt update && sudo apt upgrade -y

# 安装必要的软件
sudo apt install -y build-essential pkg-config libssl-dev git-all
sudo apt install -y protobuf-compiler
sudo apt install -y rustc cargo

# 安装 Nexus CLI
curl https://cli.nexus.xyz/ | sh

# 创建 systemd 服务文件
cat <<EOL | sudo tee /etc/systemd/system/nexus-prover.service
[Unit]
Description=Nexus Beta Prover Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/.nexus/network-api/clients/cli
ExecStart=/root/.nexus/network-api/clients/cli/target/release/prover -- beta.orchestrator.nexus.xyz
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOL

# 重新加载 systemd 配置
sudo systemctl daemon-reload

# 启动 Nexus Prover 服务
sudo systemctl start nexus-prover

# 设置服务在启动时自动启动
sudo systemctl enable nexus-prover

echo "Nexus Prover setup complete!"
