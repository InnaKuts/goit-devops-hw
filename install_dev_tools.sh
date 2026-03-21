#!/bin/bash
#
# install_dev_tools.sh — Docker, Docker Compose, Python 3.9+, Django (Ubuntu/Debian)
# Run with: sudo ./install_dev_tools.sh
#

set -e

echo "=== DevOps tools installer ==="

. /etc/os-release
DOCKER_DISTRO=$ID

# --- Docker ---
if command -v docker &>/dev/null; then
    echo "Installed Docker: $(docker --version) (already present)"
else
    echo "Installing Docker..."
    apt-get update -qq
    apt-get install -y ca-certificates curl gnupg
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL "https://download.docker.com/linux/${DOCKER_DISTRO}/gpg" | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${DOCKER_DISTRO} ${VERSION_CODENAME} stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -qq
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
    echo "Installed Docker: $(docker --version)"
fi

# --- Docker Compose ---
if docker compose version &>/dev/null || command -v docker-compose &>/dev/null; then
    echo "Installed Docker Compose: $(docker compose version 2>/dev/null || docker-compose --version) (already present)"
else
    echo "Installing Docker Compose..."
    apt-get update -qq
    apt-get install -y docker-compose-plugin
    echo "Installed Docker Compose: $(docker compose version)"
fi

# --- Python 3.9+ (and pip for Django) ---
if ! command -v python3 &>/dev/null || ! python3 -c "import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)" 2>/dev/null; then
    echo "Installing Python..."
    apt-get update -qq
    apt-get install -y python3 python3-pip python3-venv
    echo "Installed Python: $(python3 --version)"
elif ! python3 -m pip --version &>/dev/null; then
    echo "Installing pip (python3-pip)..."
    apt-get update -qq
    apt-get install -y python3-pip
    echo "Installed pip for $(python3 --version)"
else
    echo "Installed Python: $(python3 --version) (already present)"
fi

# --- Django ---
if python3 -c "import django" 2>/dev/null; then
    echo "Installed Django: $(python3 -c 'import django; print(django.get_version())') (already present)"
else
    echo "Installing Django..."
    python3 -m pip install --upgrade pip
    python3 -m pip install django
    echo "Installed Django: $(python3 -c 'import django; print(django.get_version())')"
fi

echo ""
echo "=== Done ==="
