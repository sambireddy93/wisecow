#!/bin/bash

#system-health-monitoring

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="/var/log/system_health.log"

# Create log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    sudo touch "$LOG_FILE"
    sudo chmod 666 "$LOG_FILE"
fi

# Timestamp
timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Check CPU usage
check_cpu() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    CPU_USAGE=${CPU_USAGE%.*}
    if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
        echo "$(timestamp) ⚠️ CPU usage high: ${CPU_USAGE}%" | tee -a "$LOG_FILE"
    else
        echo "$(timestamp) ✅ CPU usage normal: ${CPU_USAGE}%"
    fi
}

# Check Memory usage
check_memory() {
    MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    MEM_USAGE=${MEM_USAGE%.*}
    if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
        echo "$(timestamp) ⚠️ Memory usage high: ${MEM_USAGE}%" | tee -a "$LOG_FILE"
    else
        echo "$(timestamp) ✅ Memory usage normal: ${MEM_USAGE}%"
    fi
}

# Check Disk usage
check_disk() {
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
        echo "$(timestamp) ⚠️ Disk usage high: ${DISK_USAGE}%" | tee -a "$LOG_FILE"
    else
        echo "$(timestamp) ✅ Disk usage normal: ${DISK_USAGE}%"
    fi
}

# Check number of running processes
check_processes() {
    PROC_COUNT=$(ps -e --no-headers | wc -l)
    echo "$(timestamp) ℹ️ Running processes: $PROC_COUNT"
}

# Run all checks
echo "========================================"
echo "$(timestamp) - System Health Check"
echo "========================================"

check_cpu
check_memory
check_disk
check_processes

echo "----------------------------------------"

