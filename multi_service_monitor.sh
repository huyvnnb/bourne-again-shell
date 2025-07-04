#!/bin/bash

function check_service() {
	local service_name="$1"

	echo "----- Checking: ${service_name} -----"
	systemctl is-active --quiet "${service_name}"

	if [ $? -eq 0 ]; then
		echo "OK: Service ${service_name} is running."
	else
		echo "WARNING: '${service_name}' is NOT running! Attempting to restart..."
    		sudo systemctl start "${service_name}"

		systemctl  is-active --quiet "${service_name}"
		if [ $? -eq 0 ]; then
			echo "SUCCESS: Service ${service_name} restarted successfully."
		else
			echo "CRITICAL: Failed to restart '${service_name}'."
			send_alert "Service ${service_name} on host '$(hostname)' failed to restart."
		fi
	fi
}

function send_alert() {
	local message="$1"
	local slack_webhook_url="https://hooks.slack.com/services/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"
	local hostname=$(hostname)

	local slack_payload
	slack_payload=$(printf '{
	    "blocks": [
      	{
        "type": "header",
        "text": {
          "type": "plain_text",
          "text": ":rotating_light: CRITICAL ALERT :rotating_light:",
          "emoji": true
        }
      },
      {
        "type": "section",
        "fields": [
          {
            "type": "mrkdwn",
            "text": "*Host:*\n`%s`"
          },
          {
            "type": "mrkdwn",
            "text": "*Message:*\n%s"
          }
        ]
      },
      {
        "type": "context",
        "elements": [
          {
            "type": "mrkdwn",
            "text": "Alert triggered at: *%s*"
          }
        ]
      }
    ]
  }' "$hostname" "$message" "$(date)")

	curl -X POST -H "Content-Type: application/json" --data "${slack_payload}" "${slack_webhook_url}" &> /dev/null
}


if [ $# -eq 0 ]; then
	echo "Usage: $0 <service1> <service2> ..."
	echo "Example: $0 nginx cron"
	exit 1
fi

for service in "$@"; do
	check_service "${service}"
	echo
done
