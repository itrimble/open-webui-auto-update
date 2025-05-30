#!/bin/bash

# Migration script to move existing Open WebUI to Docker Compose

echo "🔄 Migrating existing Open WebUI to Docker Compose setup..."

# Check if container exists
if ! docker ps -a | grep -q open-webui; then
    echo "❌ No existing Open WebUI container found"
    exit 1
fi

# Get existing volume info
echo "📊 Checking existing volume..."
EXISTING_VOLUME=$(docker inspect open-webui --format='{{range .Mounts}}{{if eq .Destination "/app/backend/data"}}{{.Source}}{{end}}{{end}}' 2>/dev/null)

if [ -n "$EXISTING_VOLUME" ]; then
    echo "✅ Found existing data at: $EXISTING_VOLUME"
else
    echo "⚠️  No existing volume found. A new one will be created."
fi

# Stop existing container
echo "🛑 Stopping existing container..."
docker stop open-webui

# Remove existing container (data is preserved in volume)
echo "🗑️  Removing old container..."
docker rm open-webui

# Start with docker compose
echo "🚀 Starting with Docker Compose..."
cd "$(dirname "$0")"
docker compose up -d

# Wait for health check
echo "⏳ Waiting for Open WebUI to be healthy..."
sleep 10

# Check status
if docker ps | grep -q open-webui; then
    echo "✅ Migration completed successfully!"
    echo "🌐 Access Open WebUI at: http://localhost:3000"
    echo ""
    echo "📝 Next steps:"
    echo "1. To update manually: ./update-open-webui.sh"
    echo "2. To enable auto-updates: ./setup-auto-update.sh"
    echo "3. Or use Watchtower: docker compose -f docker-compose-with-watchtower.yml up -d"
else
    echo "❌ Migration failed. Check logs with: docker compose logs"
    exit 1
fi
