#!/bin/bash

# --- Repository Configuration ---
REPO_BASE_URL="http://95.170.219.14:4200/"
REPO_SUITE="custom"
REPO_COMPONENTS="main proprietary"
REPO_GPG_KEY_FILE="ASIO-KEY.asc"
REPO_SOURCE_FILE="/etc/apt/sources.list.d/asio.list"

echo "--- ASIO Repository Installer ---"

# Check for required tools (curl or wget)
if command -v curl &> /dev/null; then
    DOWNLOADER="curl -sL"
elif command -v wget &> /dev/null; then
    DOWNLOADER="wget -qO-"
else
    sudo apt install wget
    exit 1
fi

echo "1. Importing GPG Public Key..."
# The public key is retrieved from the web server and piped to the appropriate APT location.
# This assumes the key is named ASIO-KEY.asc and placed in the repository root.

KEY_URL="${REPO_BASE_URL}/${REPO_GPG_KEY_FILE}"
KEY_DESTINATION="/etc/apt/trusted.gpg.d/asio.asc"

# Use curl or wget to download the key and pipe it to the secure APT location
$DOWNLOADER "$KEY_URL" | sudo tee "$KEY_DESTINATION" > /dev/null

if [ $? -eq 0 ]; then
    echo "   ✅ Key imported successfully."
else
    echo "   ❌ ERROR: Failed to download or import GPG key from $KEY_URL. Check server connection and key path."
    exit 1
fi

# ---

echo "2. Adding Repository Source to APT..."
# Define the repository source line
REPO_LINE="deb [signed-by=$KEY_DESTINATION] $REPO_BASE_URL $REPO_SUITE $REPO_COMPONENTS"

# Write the source line to the dedicated file
echo "$REPO_LINE" | sudo tee "$REPO_SOURCE_FILE" > /dev/null

if [ $? -eq 0 ]; then
    echo "   ✅ Source line added to $REPO_SOURCE_FILE."
else
    echo "   ❌ ERROR: Failed to write to $REPO_SOURCE_FILE."
    exit 1
fi

# ---

echo "3. Updating Package Lists..."
sudo apt update

if [ $? -eq 0 ]; then
    echo "---"
    echo "🎉 ASIO Repository is installed and ready to use!"
    echo "You can now install packages from the 'main' (open source) and 'proprietary' (closed source) components."
else
    echo "---"
    echo "⚠️ Warning: apt update failed. Check the error output above, but the repository configuration should be correct."
fi
