#!/bin/bash

# Script: Generate and place a Launch Agent plist to set the GUI environment PATH using the current shell's PATH

# --- Configuration ---
# Label name for the generated Launch Agent (should be unique)
PLIST_LABEL="com.user.setenv.path.manual"
# Output path for the plist file
PLIST_FILENAME="$HOME/Library/LaunchAgents/${PLIST_LABEL}.plist"

# --- Main Process ---

echo "--------------------------------------------------"
echo "Generating plist to set the GUI environment PATH based on the current shell's PATH."
echo "--------------------------------------------------"
echo ""

# 1. Get the current shell's PATH
current_path="$PATH"
if [[ -z "$current_path" ]]; then
  echo "Error: Could not get the current shell's PATH." >&2
  exit 1
fi
echo "[1/3] Retrieved the current shell's PATH:"
echo "      PATH=$current_path"
echo ""

# 2. Generate the Launch Agent plist content
#    Configures ProgramArguments to execute launchctl setenv PATH "$current_path"
read -r -d '' plist_content <<EOM
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${PLIST_LABEL}</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/launchctl</string>
        <string>setenv</string>
        <string>PATH</string>
        <string>${current_path}</string> </array>
    <key>RunAtLoad</key>
    <true/> </dict>
</plist>
EOM

echo "[2/3] Generated the Launch Agent plist content."
echo "      Label: ${PLIST_LABEL}"
echo ""

# 3. Write the plist file to ~/Library/LaunchAgents/
echo "[3/3] Writing the plist file..."
echo "      Filename: $PLIST_FILENAME"

# Create ~/Library/LaunchAgents directory if it doesn't exist
mkdir -p "$(dirname "$PLIST_FILENAME")"

# Write content to the plist file (overwrite if exists)
echo "$plist_content" >"$PLIST_FILENAME"

if [[ $? -ne 0 ]]; then
  echo "Error: Failed to write the plist file." >&2
  exit 1
fi
echo "      Write operation completed."
echo ""
echo "--------------------------------------------------"
echo "Plist file generation and placement complete."
echo ""
echo "★★★ Next Steps ★★★"
echo "To apply the settings, please perform one of the following actions:"
echo ""
echo "  1. Execute the following command in the Terminal:"
echo "     (This unloads any existing configuration and loads the new one)"
echo ""
echo "     launchctl unload '$PLIST_FILENAME' 2>/dev/null ; launchctl load -w '$PLIST_FILENAME'"
echo ""
echo "  or"
echo ""
echo "  2. Log out of your Mac and log back in."
echo ""
echo "Note: Some GUI applications may require a restart or a Mac re-login for the changes to take effect."
echo "--------------------------------------------------"

exit 0
