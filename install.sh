#!/bin/bash

# Open WebUI Auto-Update System Installer
# Author: Ian Trimble
# Version: 1.0.0

set -e

echo "🚀 Open WebUI Auto-Update System Installer"
echo "=========================================="
echo "Author: Ian Trimble"
echo "Version: 1.0.0"
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed!"
    echo "Please install Docker Desktop for Mac from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "❌ Docker is not running!"
    echo "Please start Docker Desktop and try again."
    exit 1
fi

echo "✅ Docker is installed and running"

# Check if Open WebUI is already running
if docker ps | grep -q open-webui; then
    echo "⚠️  Existing Open WebUI container detected"
    echo "Would you like to migrate it to this system? (yes/no)"
    read -r MIGRATE
    if [ "$MIGRATE" = "yes" ]; then
        NEEDS_MIGRATION=true
    else
        echo "Please stop the existing container first: docker stop open-webui"
        exit 1
    fi
else
    NEEDS_MIGRATION=false
fi

# Make all scripts executable
echo ""
echo "🔧 Setting up scripts..."
chmod +x *.sh
echo "✅ Scripts are executable"

# Create necessary directories
echo ""
echo "📁 Creating directories..."
mkdir -p backups
echo "✅ Directories created"

# Run migration if needed
if [ "$NEEDS_MIGRATION" = true ]; then
    echo ""
    echo "🔄 Migrating existing Open WebUI..."
    ./migrate-to-compose.sh
else
    echo ""
    echo "🐳 Starting Open WebUI..."
    docker compose up -d
    
    echo "⏳ Waiting for container to be healthy..."
    sleep 15
fi

# Verify installation
echo ""
echo "🔍 Verifying installation..."
if docker ps | grep -q open-webui; then
    echo "✅ Open WebUI is running!"
else
    echo "❌ Open WebUI failed to start. Check logs: docker compose logs"
    exit 1
fi

# Ask about automatic updates
echo ""
echo "🤖 Would you like to enable automatic daily updates? (yes/no)"
read -r AUTO_UPDATE

if [ "$AUTO_UPDATE" = "yes" ]; then
    ./setup-auto-update.sh
fi

# Create initial backup
echo ""
echo "💾 Creating initial backup..."
./backup-open-webui.sh

# Show summary
echo ""
echo "✨ Installation Complete!"
echo "========================"
echo ""
echo "📍 Open WebUI URL: http://localhost:3000"
echo "📁 Installation directory: $(pwd)"
echo "🔄 Auto-updates: $([ "$AUTO_UPDATE" = "yes" ] && echo "Enabled (3 AM daily)" || echo "Disabled")"
echo ""
echo "📚 Useful commands:"
echo "  Check status:  docker ps | grep open-webui"
echo "  View logs:     docker compose logs -f"
echo "  Manual update: ./update-open-webui.sh"
echo "  Backup:        ./backup-open-webui.sh"
echo ""
echo "For more information, see README.md"
echo ""
echo "Enjoy your auto-updating Open WebUI! 🎉"
