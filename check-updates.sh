#!/bin/bash

# Check for Open WebUI updates

echo "🔍 Checking for Open WebUI updates..."

# Pull the latest image metadata without downloading
docker pull ghcr.io/open-webui/open-webui:main --dry-run 2>/dev/null || docker pull ghcr.io/open-webui/open-webui:main

# Get current and latest image IDs
CURRENT_IMAGE=$(docker inspect open-webui --format='{{.Image}}' 2>/dev/null)
LATEST_IMAGE=$(docker inspect ghcr.io/open-webui/open-webui:main --format='{{.Id}}' 2>/dev/null)

echo ""
echo "📊 Version Information:"
echo "Current Image ID: ${CURRENT_IMAGE:0:12}"
echo "Latest Image ID:  ${LATEST_IMAGE:0:12}"

if [ "$CURRENT_IMAGE" = "$LATEST_IMAGE" ]; then
    echo ""
    echo "✅ You're running the latest version!"
else
    echo ""
    echo "🆕 A new version is available!"
    echo "Run './update-open-webui.sh' to update"
fi

# Show container status
echo ""
echo "📦 Container Status:"
docker ps --filter "name=open-webui" --format "table {{.Names}}\t{{.Status}}\t{{.CreatedAt}}"

# Check latest releases from GitHub
echo ""
echo "📰 Latest GitHub Releases:"
curl -s https://api.github.com/repos/open-webui/open-webui/releases | grep -E '"tag_name"|"published_at"' | head -6 | sed 's/"tag_name":/Release:/' | sed 's/"published_at":/Date:/'
