#!/usr/bin/bash

response=$(curl -s -m 3 -w "\n%{http_code}" https://nordvpn.com/wp-admin/admin-ajax.php?action=get_user_info_data)
status_code="$(echo -e "$response" | tail -n 1)"
response_text="$(echo -e "$response" | head -n -1)"
vpn_status="$(echo -e "$response_text" | jq -r '.status')"
country_code="$(echo -e "$response_text" | jq -r '.country_code')"
if [ "$status_code" = "200" ]; then
    if [ "$vpn_status" = "true" ]; then
        echo "❄️"
        echo "---"
        echo "Connected to $country_code"
    else
        echo "|"
    fi
else
    echo "..."
fi
