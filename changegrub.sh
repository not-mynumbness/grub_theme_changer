#!/bin/bash
## 2022-2024 Deff Nog, Not My Numbness
## Basic Grub Theme Changer
# Define the theme directory
THEME_DIR="/boot/grub/themes"
# Function to pick a random theme
pick_theme() {
    THEMES=($(ls "$THEME_DIR"))
    r=$((RANDOM % ${#THEMES[@]}))
    printf "%s\n" "${THEMES[$r]}"
}
# Function to update the grub config
update_grub_config() {
    THEME_NAME="$1"
    if [ -f "$THEME_DIR/$THEME_NAME/theme.txt" ]; then
        echo "GRUB_THEME=\"$THEME_DIR/$THEME_NAME/theme.txt\"" >> /etc/default/grub
        return 0
    else
        echo "Error: Theme '$THEME_NAME' does not have a valid theme.txt file."
        return 1
    fi
}
# Function to check if a command is available
has_command() {
  command -v "$1" > /dev/null
}
# Function to update grub
update_grub() {
    if has_command update-grub; then
        update-grub
    elif has_command updategrube; then
        updategrub
    elif has_command grub-mkconfig; then
        grub-mkconfig -o /boot/grub/grub.cfg
    else
        echo "Error: Neither updategrub nor grub-mkconfig is available."
        exit 1
    fi
}
# Main script
if [ "$UID" -eq 0 ]; then
    # Backup grub config
    echo -e "\tBacking up grub config..."
    #TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    cp -an /etc/default/grub "/etc/default/grub.bak"
    # Remove existing GRUB_THEME line
    grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub
    # Pick a random theme and update grub config
    THEME_NAME=$(pick_theme)
    if update_grub_config "$THEME_NAME"; then
        # Update grub
        echo -e "\t\e[1mUpdating grub...\e[0m"
        update_grub
        echo -e "\e[1mINSTALLED \x1b[5m$THEME_NAME!\x1b[25m - Deffn Grub Changer \e[0m"
    else
        echo -e "\e[1mError: Failed to update grub config.\e[0m"
        exit 1
    fi
else
    echo -e "\e[1mError: This script requires root access.\e[0m"
    exit 1
fi