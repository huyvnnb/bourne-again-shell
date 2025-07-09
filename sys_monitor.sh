#!/bin/bash

CPU_THRESHOLD=80 # %
RAM_THRESHOLD=500 # MB
DISK_THRESHOLD=90 # %
EMAIL_ADD=""

LOG_FILE="/var/log/sys_monitor.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

CPU_USAGE=$(vmstat | tail -n 1 | awk '{print 100 - $15}')

RAM_FREE=$(free -m | awk '/^Mem/ {print $4}')

DISK_USAGE=$(df / | tail -n -1 | awk '{print $5}' | tr -d '%')

SHOW_INFO=false
while [[ $# -gt 0 ]]; do
	case "$1" in
		-i|--info)
			SHOW_INFO=true
			shift
			;;
		-a|--alert)
			if [[ -n "$2" && "$2" != -* ]]; then
				EMAIL_ADD="$2"
				shift 2
			else
				echo "Error: Option '$1' requires an email address as argument." >&2
				exit 1
			fi
			;;

		*)
			echo "Unknown option: $1"
			exit 1
			;;
	esac
done

if $SHOW_INFO; then
	echo "------------SYSTEM MONITOR------------"
	echo "CPU: $CPU_USAGE%"
	echo "RAM_FREE: $RAM_FREE MB"
	echo "DISK_USAGE: $DISK_USAGE%"
	echo "--------------------------------------"
fi


ALERT_MSG=""

if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
	ALERT_MSG+="[!] CPU usage is high: %CPU_USAGE%\n"
fi

if [ "$RAM_FREE" -lt "$RAM_THRESHOLD" ]; then
	ALERT_MSG+="[!] Free RAM is low: $RAM_FREE MB\n"
fi

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
	ALERT_MSG+="[!] Disk usage is high: $DISK_USAGE%\n"
fi

if [ -n "$ALERT_MSG" ]; then
	echo -e "[$DATE]\n$ALERT_MSG" >> "$LOG_FILE"
	if [ -n "$EMAIL_ADD" ]; then
		echo -e "$ALERT_MSG" | mail -s "System alert on $(hostname)" "$EMAIL_ADD"
	fi
fi
