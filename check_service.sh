#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <service name>" >&2
	exit 1
fi

service=$1
systemctl is-active --quiet "$service"

if [ $? -eq 0 ]; then
	echo "OK: Service '${service}' is running"
	exit 0
else
	echo "WARNING: Service '${service}' is not running." 
	echo "Attempting to restart..."
	sudo systemctl start "$service"

	systemctl is-active --quiet "${service}"
	if [ $? -eq 0 ]; then
		echo "SUCCESS: Service ${service} started successfully"
		exit 0
	else:
		echo "CRITICAL: Failed to restart service '${service}'. Manual intervention required."
    		exit 1
	fi
fi
