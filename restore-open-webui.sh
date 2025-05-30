#!/bin/bash

# Open WebUI Restore Script
# Restores Open WebUI data from a backup

BACKUP_DIR="$HOME/open-webui/backups"

echo "🔄 Open WebUI Restore Tool"
echo ""

# List available backups
echo "📁 Available backups:"
ls -lh "$BACKUP_DIR"/open-webui-backup-*.tar.gz 2>/dev/null | nl -v 0

if [ $? -ne 0 ]; then
    echo "❌ No backups found in $BACKUP_DIR"
    exit 1
fi

echo ""
echo "Enter the number of the backup to restore (or full filename):"
read -r SELECTION

# Handle numeric selection
if [[ "$SELECTION" =~ ^[0-9]+$ ]]; then
    BACKUP_FILE=$(ls -t "$BACKUP_DIR"/open-webui-backup-*.tar.gz | sed -n "$((SELECTION+1))p")
else
    BACKUP_FILE="$BACKUP_DIR/$SELECTION"
fi

# Verify file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo ""
echo "⚠️  WARNING: This will replace all current Open WebUI data!"
echo "Backup to restore: $(basename "$BACKUP_FILE")"
echo "Continue? (yes/no)"
read -r CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "❌ Restore cancelled"
    exit 0
fi

# Stop Open WebUI
echo "🛑 Stopping Open WebUI..."
cd "$(dirname "$0")"
docker compose down

# Restore the backup
echo "📥 Restoring backup..."
docker run --rm \
  -v open-webui-data:/data \
  -v "$BACKUP_DIR":/backup \
  alpine sh -c "rm -rf /data/* && tar xzf '/backup/$(basename "$BACKUP_FILE")' -C /data"

if [ $? -eq 0 ]; then
    echo "✅ Restore completed successfully!"
    
    # Start Open WebUI
    echo "🚀 Starting Open WebUI..."
    docker compose up -d
    
    echo ""
    echo "⏳ Waiting for Open WebUI to be healthy..."
    sleep 10
    
    docker ps --filter "name=open-webui"
    echo ""
    echo "✅ Restore complete! Access Open WebUI at: http://localhost:3000"
else
    echo "❌ Restore failed!"
    exit 1
fi
