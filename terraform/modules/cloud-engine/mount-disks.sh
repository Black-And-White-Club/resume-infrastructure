#!/bin/bash
# Startup script to mount frolf-bot disks

set -e

echo "Starting disk mount script..."

# Function to mount disk if not already mounted
mount_disk_if_needed() {
    local device=$1
    local mount_point=$2
    local label=$3
    
    echo "Processing $label: $device -> $mount_point"
    
    # Check if already mounted
    if mountpoint -q "$mount_point"; then
        echo "$label is already mounted at $mount_point"
        return 0
    fi
    
    # Create mount point if it doesn't exist
    if [ ! -d "$mount_point" ]; then
        echo "Creating mount point: $mount_point"
        mkdir -p "$mount_point"
    fi
    
    # Check if device exists
    if [ ! -b "$device" ]; then
        echo "WARNING: Device $device does not exist yet. Skipping $label."
        return 1
    fi
    
    # Mount the disk
    echo "Mounting $device to $mount_point"
    mount "$device" "$mount_point"
    
    # Set permissions
    chmod 755 "$mount_point"
    
    echo "$label mounted successfully"
}

# Wait a bit for devices to be available
sleep 5

# Mount frolf-bot postgres disk
# Device name is based on the device_name in Terraform
mount_disk_if_needed "/dev/disk/by-id/google-frolf-bot-postgres" "/mnt/frolf_postgres" "Frolf-Bot Postgres"

# Mount frolf-bot grafana disk
mount_disk_if_needed "/dev/disk/by-id/google-frolf-bot-grafana" "/mnt/frolf_grafana" "Frolf-Bot Grafana"

# Update /etc/fstab if entries don't exist
if ! grep -q "frolf-bot-postgres" /etc/fstab; then
    echo "/dev/disk/by-id/google-frolf-bot-postgres /mnt/frolf_postgres ext4 defaults,nofail 0 2" >> /etc/fstab
    echo "Added frolf-bot-postgres to /etc/fstab"
fi

if ! grep -q "frolf-bot-grafana" /etc/fstab; then
    echo "/dev/disk/by-id/google-frolf-bot-grafana /mnt/frolf_grafana ext4 defaults,nofail 0 2" >> /etc/fstab
    echo "Added frolf-bot-grafana to /etc/fstab"
fi

# Create subdirectories for grafana disk
mkdir -p /mnt/frolf_grafana/{grafana,loki,mimir-ingester,mimir-ruler,tempo,nats}
chmod -R 755 /mnt/frolf_grafana

echo "Disk mount script completed successfully"
