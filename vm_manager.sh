#!/bin/bash


function show_status() {
	echo "--- Current VM Status ----"
	vagrant status
}

function start_all() {
	echo "--- Starting all VMs ---"
	vagrant up
}

stop_all() {
	echo "--- Halting all VMs ----"
	vagrant halt
}

COMMAND=$1

case "$COMMAND" in
	"status")
		show_status
		;;
	"start")
		start_all
		;;
	"stop")
		stop_all()
		;;
	"*")
		echo "Invalid command: '$COMMAND'"
		echo "Usage: $0 {status|start|stop}"
		exit 1
		;;
esac

exit 0
