#!/bin/bash

# services to disable/mask
SERVICES=(
  avahi-daemon.service
  bluetooth.service
  cups.service
  ModemManager.service
  switcheroo-control.service
  avahi-daemon.socket
  cups.socket
  cups.path
)

echo "Disabling and masking unnecessary services..."

for svc in "${SERVICES[@]}"; do
  if systemctl list-unit-files | grep -q "$svc"; then
    echo "Disabling $svc ..."
    sudo systemctl stop "$svc" 2>/dev/null
    sudo systemctl disable "$svc" 2>/dev/null
    sudo systemctl mask "$svc" 2>/dev/null
  else
    echo "$svc not found on this system. Skipping."
  fi
done

