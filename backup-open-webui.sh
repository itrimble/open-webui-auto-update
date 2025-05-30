#!/bin/bash

# Open WebUI Backup Script
# Creates timestamped backups of your Open WebUI data

BACKUP_DIR="$HOME/open-webui/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="open-webui-backup-${TIMESTAMP}"

echo "🔒 Starting Open WebUI backup..."

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create a temporary container to access the volume
echo "📦 Creating backup from Docker volume..."
docker run --rm \
  -v open-webui-data:/data \
  -v "$BACKUP_DIR":/backup \
  alpine tar czf "/backup/${BACKUP_NAME}.tar.gz" -C /data .

if [ $? -eq 0 ]; then
    echo "✅ Backup created successfully!"
    echo "📍 Location: $BACKUP_DIR/${BACKUP_NAME}.tar.gz"
    
    # Show backup size
    BACKUP_SIZE=$(ls -lh "$BACKUP_DIR/${BACKUP_NAME}.tar.gz" | awk '{print $5}')
    echo "📊 Size: $BACKUP_SIZE"
    
    # Keep only last 7 backups
    echo "🧹 Cleaning old backups (keeping last 7)..."
    cd "$BACKUP_DIR"
    ls -t open-webui-backup-*.tar.gz | tail -n +8 | xargs -r rm
    
    # List current backups
    echo ""
    echo "📁 Current backups:"
    ls -lh open-webui-backup-*.tar.gz | head -7
else
    echo "❌ Backup failed!"
    exit 1
fi
