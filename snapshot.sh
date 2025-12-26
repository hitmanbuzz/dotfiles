#!/bin/bash

# ==========================================
# Arch Linux Snapper FIX Script (Aggressive Clean)
# ==========================================

# 1. FORCE ROOT EXECUTION
if [[ $EUID -ne 0 ]]; then
   echo "CRITICAL ERROR: This script must be run with sudo." 
   exit 1
fi

echo "-> STARTING AGGRESSIVE CLEANUP..."

# 2. Unmount /.snapshots if it's mounted
# We try multiple times to be sure
umount -f /.snapshots 2>/dev/null
umount -R /.snapshots 2>/dev/null

# 3. Remove conflicting config files manually
# Snapper sometimes leaves a broken config file that blocks re-creation
if [[ -f "/etc/snapper/configs/root" ]]; then
    echo "-> Removing broken snapper config file..."
    rm -f /etc/snapper/configs/root
fi

# Remove 'root' from the global snapper config list
if [[ -f "/etc/conf.d/snapper" ]]; then
    sed -i 's/root//g' /etc/conf.d/snapper
fi

# 4. Nuclear Option: Delete /.snapshots Subvolume by ID
# This bypasses path issues if the directory structure is confused
echo "-> Finding and deleting /.snapshots subvolume..."
SUBVOL_ID=$(btrfs subvolume list / | grep ".snapshots" | awk '{print $2}')

if [[ -n "$SUBVOL_ID" ]]; then
    echo "   Found persistent subvolume ID: $SUBVOL_ID. Deleting by ID..."
    btrfs subvolume delete --subvolid "$SUBVOL_ID" /
else
    echo "   No subvolume ID found. Checking for directory..."
fi

# 5. Remove directory remnants
# If it was just a directory (not a subvolume), this kills it
if [[ -d "/.snapshots" ]]; then
    echo "   Removing /.snapshots directory..."
    rm -rf /.snapshots
fi

# 6. Re-create the Snapper Config
echo "-> Creating new Snapper configuration..."
snapper -c root create-config /

# 7. Verify Success immediately
if [[ -f "/etc/snapper/configs/root" ]]; then
    echo "-> SUCCESS: Config created!"
else
    echo "-> ERROR: Config creation still failed."
    exit 1
fi

# 8. Set Permissions (The fix for your "No permissions" error)
# We detect the user who called sudo to set ownership correctly
REAL_USER=${SUDO_USER:-$USER}
echo "-> Setting permissions for user: $REAL_USER"
chmod 750 /.snapshots
chown :"$REAL_USER" /.snapshots

# 9. Configure Limits (Reduce disk usage)
sed -i 's/^NUMBER_LIMIT="50"/NUMBER_LIMIT="10"/' /etc/snapper/configs/root
sed -i 's/^TIMELINE_LIMIT_HOURLY="10"/TIMELINE_LIMIT_HOURLY="5"/' /etc/snapper/configs/root
sed -i 's/^TIMELINE_LIMIT_DAILY="10"/TIMELINE_LIMIT_DAILY="7"/' /etc/snapper/configs/root

# 10. Install & Enable GRUB BTRFS (If missing)
echo "-> Checking GRUB integration..."
if ! pacman -Qi grub-btrfs &> /dev/null; then
    echo "   Installing grub-btrfs..."
    pacman -S --noconfirm grub-btrfs
fi

systemctl enable --now grub-btrfs.path
echo "-> Updating GRUB..."
grub-mkconfig -o /boot/grub/grub.cfg

# 11. Create First Snapshot
echo "-> Creating test snapshot..."
snapper -c root create --description "Fix Applied Successfully"

echo "=========================================="
echo "DONE. Check with: snapper -c root list"
echo "=========================================="
