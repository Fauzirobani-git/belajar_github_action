#!/bin/bash

echo "==== SERVER PERFORMANCE STATS ===="
echo "Generated on: $(date)"
echo

# OS Version
echo ">> OS Version:"
cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"'
echo

# Uptime
echo ">> Uptime:"
uptime -p
echo

# Load Average
echo ">> Load Average (1m, 5m, 15m):"
uptime | awk -F'load average:' '{ print $2 }'
echo

# Logged In Users
echo ">> Logged in users:"
who | wc -l
echo

# CPU Usage
echo ">> Total CPU Usage:"
top -bn1 | grep "Cpu(s)" | \
  awk '{print "Used: " 100 - $8 "%", " | Idle: " $8 "%"}'
echo

# Memory Usage
echo ">> Memory Usage:"
free -h | awk '/Mem:/ { 
    used=$3; free=$4; total=$2;
    printf("Used: %s | Free: %s | Total: %s | Usage: %.2f%%\n", used, free, total, $3/$2 * 100)
}'
echo

# Disk Usage
echo ">> Disk Usage (/):"
df -h / | awk 'NR==2 { 
    printf("Used: %s | Available: %s | Total: %s | Usage: %s\n", $3, $4, $2, $5)
}'
echo

# Top 5 Processes by CPU
echo ">> Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo

# Top 5 Processes by Memory
echo ">> Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
echo

# Stretch: Failed login attempts (last 24 hours)
echo ">> Failed Login Attempts (last 24h):"
journalctl -xe | grep "Failed password" | grep "$(date '+%b %_d')" | wc -l
