#!/usr/bin/env bash

LOGFILE=/var/log/deploy_alerts.log

USAGE=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

if (( USAGE > 80)); 
then
  echo "$(date +'%Y-%m-%dT%H:%M:%S') DISK WARNING: Usage at ${USAGE}% on /" >> "${LOGFILE}"
fi
