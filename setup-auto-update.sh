#!/bin/bash

# Setup automatic updates for Open WebUI

echo "📅 Setting up automatic daily updates for Open WebUI..."

# Create a LaunchDaemon plist for macOS (runs daily at 3 AM)
cat > ~/Library/LaunchAgents/com.openwebui.autoupdate.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.openwebui.autoupdate</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/ian/open-webui/update-open-webui.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>3</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/Users/ian/open-webui/update.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/ian/open-webui/update-error.log</string>
</dict>
</plist>
EOF

# Load the LaunchAgent
launchctl load ~/Library/LaunchAgents/com.openwebui.autoupdate.plist

echo "✅ Automatic updates configured!"
echo "📍 Updates will run daily at 3 AM"
echo "📄 Logs will be saved to: /Users/ian/open-webui/update.log"
echo ""
echo "To disable automatic updates, run:"
echo "launchctl unload ~/Library/LaunchAgents/com.openwebui.autoupdate.plist"
