#!/bin/bash

# Open WebUI Update Script
# This script updates Open WebUI to the latest version

echo "🔄 Updating Open WebUI to the latest version..."

# Navigate to the Open WebUI directory
cd "$(dirname "$0")"

# Pull the latest image
echo "📥 Pulling latest Open WebUI image..."
docker compose pull

# Check if there's a new image
CURRENT_IMAGE=$(docker inspect open-webui --format='{{.Image}}' 2>/dev/null)
LATEST_IMAGE=$(docker inspect ghcr.io/open-webui/open-webui:main --format='{{.Id}}' 2>/dev/null)

if [ "$CURRENT_IMAGE" = "$LATEST_IMAGE" ]; then
    echo "✅ Open WebUI is already up to date!"
    exit 0
fi

echo "🚀 New version available! Updating..."
echo "📌 Note: All your settings, chats, and data will be preserved!"

# Create backup before updating
echo "🔒 Creating backup before update..."
./backup-open-webui.sh
if [ $? -ne 0 ]; then
    echo "⚠️  Backup failed. Continue anyway? (yes/no)"
    read -r CONTINUE
    if [ "$CONTINUE" != "yes" ]; then
        echo "❌ Update cancelled"
        exit 1
    fi
fi

# Stop and remove the old container
echo "🛑 Stopping current container..."
docker compose down

# Start with the new image
echo "▶️  Starting updated Open WebUI..."
docker compose up -d

# Wait for health check
echo "⏳ Waiting for Open WebUI to be healthy..."
sleep 10

# Check if the container is running
if docker ps | grep -q open-webui; then
    echo "✅ Open WebUI updated successfully!"
    echo "🌐 Access it at: http://localhost:3000"
    
    # Show the new version info
    echo ""
    echo "📊 Container Info:"
    docker ps --filter "name=open-webui" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
    echo "❌ Failed to start Open WebUI. Check logs with: docker compose logs"
    exit 1
fi
