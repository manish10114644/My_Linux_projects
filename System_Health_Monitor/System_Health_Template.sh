#!/bin/bash

# =======================================================
# Project: Automated System Health Monitor
# =======================================================

# 1. Configuration Thresholds
DISK_THRESHOLD=80
MEM_THRESHOLD=90
LOG_FILE="/var/log/system_monitor.log"

WEBHOOK_URL="https://discord.com/api/webhooks/YOUR_WEBHOOK_URL_HERE"

# 2. Extract Metrics
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

TOTAL_MEM=$(free -m | awk '/Mem:/ {print $2}')
USED_MEM=$(free -m | awk '/Mem:/ {print $3}')
MEM_USAGE=$(( USED_MEM * 100 / TOTAL_MEM ))

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# 3. Log Routine Metrics Locally
echo "[$TIMESTAMP] DISK: ${DISK_USAGE}% | MEM: ${MEM_USAGE}%" >> $LOG_FILE

# 4. Logical Check & Live Alerting for Disk Space
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
    # Log the warning locally
    echo "[$TIMESTAMP]  ALERT: Disk space critical at ${DISK_USAGE}%!" >> $LOG_FILE
    
    # Construct JSON payload for the external network call
    PAYLOAD="{\"content\": \" **CRITICAL SERVER ALERT** \n**Server:** \`manish-VirtualBox\`\n**Issue:** Disk Usage has crossed thresholds!\n**Current Disk Usage:** ${DISK_USAGE}%\n**Timestamp:** ${TIMESTAMP}\"}"
    
    # Send to the Webhook silently in the background
    curl -H "Content-Type: application/json" -X POST -d "$PAYLOAD" "$WEBHOOK_URL" 
fi

# 5. Logical Check & Live Alerting for Memory Usage
if [ $MEM_USAGE -gt $MEM_THRESHOLD ]; then
    # Log the warning locally
    echo "[$TIMESTAMP] ⚠️ ALERT: Memory allocation critical at ${MEM_USAGE}%!" >> $LOG_FILE
    
    # Construct JSON payload
    PAYLOAD="{\"content\": \"🚨 **CRITICAL SERVER ALERT** 🚨\n**Server:** \`manish-VirtualBox\`\n**Issue:** RAM allocation is dangerously high!\n**Current Memory Usage:** ${MEM_USAGE}%\n**Timestamp:** ${TIMESTAMP}\"}"
    
    # Send to the Webhook silently in the background
    curl -H "Content-Type: application/json" -X POST -d "$PAYLOAD" "$WEBHOOK_URL" > /dev/null 2>&1
fi
