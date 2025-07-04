#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

function print_title(){
	echo -e "\n${RED}---- $1 ----${NC}"
}

function get_basic_info(){
	print_title "Basic System Information"
  	echo -e "Hostname:     ${GREEN}$(hostname)${NC}"
  	echo -e "OS Version:   ${GREEN}$(lsb_release -d | cut -f2-)${NC}"
  	echo -e "Kernel:       ${GREEN}$(uname -r)${NC}"
  	echo -e "Uptime:       ${GREEN}$(uptime -p)${NC}"
}

function get_mem_cpu_info() {
  	print_title "CPU and Memory Usage"
  	echo "--- Memory ---"
	free -h
  	echo "--- Top 5 CPU Consuming Processes ---"
	ps aux | sort -nrk 3 | head -n 5
}

function get_disk_info() {
  print_title "Disk Usage"
  df -h | grep -vE 'tmpfs|udev|loop'
}

function get_network_info() {
  print_title "Network Information"
  echo "IP Addresses: ${GREEN}$(hostname -I)${NC}"
  echo "--- Open Ports (Listening) ---"
  # ss -tuln: xem các socket đang lắng nghe (l) ở cả TCP (t) và UDP (u)
  # mà không cần phân giải tên miền (n)
  ss -tuln
}

clear
echo "========================================="
echo "        SYSTEM INFORMATION REPORT        "
echo "========================================="

# Gọi các hàm đã định nghĩa theo thứ tự
get_basic_info
get_mem_cpu_info
get_disk_info
get_network_info

echo -e "\n${YELLOW}--- END OF REPORT ---${NC}"
