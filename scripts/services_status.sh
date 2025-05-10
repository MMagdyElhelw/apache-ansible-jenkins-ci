#!/bin/bash

# Print header
printf "%-40s %-10s\n" "SERVICE" "MEMORY(KB)"
printf "%-40s %-10s\n" "----------------------------------------" "----------"

services=$(systemctl list-unit-files --state=enabled --type=service | awk '/\.service/ {print $1}')

for svc in $services;
do
    # Get main PID of the service
    PID=$(systemctl show -p MainPID --value "$svc")

    # Check if PID is valid and not zero
    if [[ "$PID" != "0" && -n "$PID" ]];
    then
	mem=$(top -b -n 1 -p "$PID" | grep -w "$PID" | awk '{print $6}')
        printf "%-40s %-10s\n" "$svc" "$mem KB"
    else
        printf "%-40s %-10s\n" "$svc" "N/A"
    fi
done | sort -k2 -n

