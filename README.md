# Open WebUI Auto-Update System

> A comprehensive automation system for Open WebUI that ensures your installation stays up-to-date while preserving all your data and configurations.

**Author:** Ian Trimble  
**License:** MIT  
**Created:** May 30, 2025

## 🌟 Features

- **🔄 Automatic Daily Updates** - Scheduled updates at 3 AM via macOS LaunchAgent
- **💾 Complete Data Persistence** - All settings, chats, and uploads preserved
- **🔒 Automatic Backups** - Creates backups before each update
- **🐳 Docker Compose Integration** - Clean container management
- **📊 Health Monitoring** - Ensures container health before/after updates
- **🛡️ Rollback Capability** - Restore from any backup if needed
- **📝 Comprehensive Logging** - Track all update activities

## 🚀 Quick Start

### Prerequisites
- Docker Desktop for Mac installed and running
- Basic command line knowledge
- Open WebUI already installed (or use this to set it up fresh)

### Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/iantrimble/open-webui-auto-update.git ~/open-webui
   cd ~/open-webui
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x *.sh
   ```

3. **If you have an existing Open WebUI container:**
   ```bash
   ./migrate-to-compose.sh
   ```

4. **Enable automatic updates:**
   ```bash
   ./setup-auto-update.sh
   ```

That's it! Open WebUI will now update automatically every night at 3 AM.

## 📁 Repository Structure

```
open-webui/
├── docker-compose.yml                 # Main Docker Compose configuration
├── docker-compose-with-watchtower.yml # Alternative with Watchtower
├── update-open-webui.sh              # Core update script
├── setup-auto-update.sh              # Configure automatic updates
├── backup-open-webui.sh              # Manual backup utility
├── restore-open-webui.sh             # Restore from backup
├── check-updates.sh                  # Check for available updates
├── verify-config.sh                  # Verify persistence setup
├── test-persistence.sh               # Test data persistence
├── migrate-to-compose.sh             # Migrate existing installation
├── how-persistence-works.md          # Technical documentation
├── README.md                         # This file
├── LICENSE                           # MIT License
└── .gitignore                        # Git ignore rules
```

## 🔧 Configuration

### Docker Compose Setup
The system uses Docker Compose for container management with:
- Named volumes for data persistence
- Health checks for reliability
- Automatic restart policies
- Proper port mapping (3000:8080)

### Automatic Updates
Updates are managed by macOS LaunchAgent:
- **Schedule:** Daily at 3:00 AM
- **LaunchAgent:** `~/Library/LaunchAgents/com.openwebui.autoupdate.plist`
- **Logs:** `~/open-webui/update.log`

### Data Persistence
All data is stored in Docker volumes:
- **Database:** Settings, users, chats, configurations
- **Uploads:** Documents and files
- **Cache:** Performance data
- **Vector DB:** RAG embeddings

## 📖 Usage Guide

### Daily Operations

**Access Open WebUI:**
```bash
open http://localhost:3000
```

**Check container status:**
```bash
docker ps | grep open-webui
```

**View logs:**
```bash
docker compose logs -f
```

### Manual Updates

**Check for updates:**
```bash
./check-updates.sh
```

**Update manually:**
```bash
./update-open-webui.sh
```

### Backup Management

**Create manual backup:**
```bash
./backup-open-webui.sh
```

**Restore from backup:**
```bash
./restore-open-webui.sh
```

**Verify persistence:**
```bash
./verify-config.sh
```

### Container Management

**Stop Open WebUI:**
```bash
docker compose down
```

**Start Open WebUI:**
```bash
docker compose up -d
```

**Restart Open WebUI:**
```bash
docker compose restart
```

## 🛡️ Data Safety

### Automatic Backups
- Created before each update
- Stored in `~/open-webui/backups/`
- Last 7 backups retained
- Compressed tar.gz format

### Persistence Guarantee
The Docker volume system ensures:
- ✅ Settings persist across updates
- ✅ No manual intervention needed
- ✅ Seamless user experience
- ✅ Zero data loss

## 🔄 Update Process

1. **Check for new image** - Compares current vs latest
2. **Create backup** - Safety snapshot of current data
3. **Pull new image** - Downloads latest version
4. **Stop old container** - Graceful shutdown
5. **Start new container** - With same data volume
6. **Health check** - Ensures successful start
7. **Cleanup** - Removes old images

## 🚨 Troubleshooting

### Container won't start
```bash
# Check logs
docker compose logs

# Restart manually
docker compose down
docker compose up -d
```

### Update failed
```bash
# Check update log
cat ~/open-webui/update.log

# Restore from backup if needed
./restore-open-webui.sh
```

### Disable auto-updates
```bash
launchctl unload ~/Library/LaunchAgents/com.openwebui.autoupdate.plist
```

### Re-enable auto-updates
```bash
launchctl load ~/Library/LaunchAgents/com.openwebui.autoupdate.plist
```

## 🏗️ Advanced Options

### Using Watchtower
For continuous monitoring instead of scheduled updates:
```bash
docker compose -f docker-compose-with-watchtower.yml up -d
```

### Custom Update Schedule
Edit `~/Library/LaunchAgents/com.openwebui.autoupdate.plist` and modify:
```xml
<key>Hour</key>
<integer>3</integer>  <!-- Change this -->
<key>Minute</key>
<integer>0</integer>  <!-- And this -->
```

### Custom Backup Location
Edit `backup-open-webui.sh` and change:
```bash
BACKUP_DIR="$HOME/open-webui/backups"  # Modify this path
```

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Open WebUI](https://github.com/open-webui/open-webui) team for the excellent project
- Docker team for container technology
- The open-source community

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/iantrimble/open-webui-auto-update/issues)
- **Author:** Ian Trimble
- **Location:** Gonzales, LA

---

**Note:** This automation system is independent of the official Open WebUI project. Always check the official Open WebUI documentation for specific version requirements or breaking changes.
