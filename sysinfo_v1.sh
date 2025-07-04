#!/bin/bash

clear

echo "========================================="
echo "        SYSTEM INFORMATION REPORT        "
echo "========================================="

echo ""

echo "Hostname: $(hostname)"
echo "OS Version: $(lsb_release -d | cut -f2-)"
echo "Uptime: $(uptime -p)"

echo ""
echo "--- CPU and Memory Usage ---"
echo "$(free -h | head -n 3)"

echo ""
echo "--- Disk Usage ---"
echo "$(df -h | grep -vE 'tmpfs|udev|loop')"

echo ""
echo "--- Network Information ---"
echo "IP Addresses: $(hostname -I)"

echo ""
echo "========================================="
echo "           END OF REPORT                 "
echo "========================================="
