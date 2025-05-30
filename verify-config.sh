#!/bin/bash

# Verify Open WebUI configuration persistence

echo "🔍 Verifying Open WebUI Configuration Persistence"
echo "================================================"

# Check if container is running
if ! docker ps | grep -q open-webui; then
    echo "❌ Open WebUI container is not running"
    exit 1
fi

echo ""
echo "📊 Volume Information:"
docker inspect open-webui --format='{{range .Mounts}}Type: {{.Type}}
Source: {{.Source}}
Destination: {{.Destination}}
{{end}}'

echo ""
echo "💾 Data Directory Contents:"
docker exec open-webui ls -lah /app/backend/data/

echo ""
echo "📈 Database Size:"
docker exec open-webui du -h /app/backend/data/webui.db

echo ""
echo "📁 Volume Details:"
docker volume inspect open-webui-data 2>/dev/null || docker volume inspect open-webui_open-webui

echo ""
echo "🔐 Persisted Data Includes:"
echo "✓ webui.db - All settings, users, chats, model configs"
echo "✓ uploads/ - Uploaded documents and files"
echo "✓ cache/ - Cached data for performance"
echo "✓ vector_db/ - RAG vector database"
echo "✓ logs/ - Application logs (if configured)"

echo ""
echo "💡 Tips for Data Safety:"
echo "1. Automatic backups are created before each update"
echo "2. Run './backup-open-webui.sh' for manual backups"
echo "3. Backups are stored in: ~/open-webui/backups/"
echo "4. Keep at least 1 backup from a known good state"
