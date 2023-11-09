#!/usr/bin/env bash

# Define the repositories to check
repositories=(
    "surfly/cobro"
    # "surfly/deployment"
    # "surfly/install"
    # "surfly/session-recording"
    # "surfly/ci"
)

# Initialize the total number of pull requests to 0
total_vulnerabilities=0

# Loop through the repositories and add up the number of pending vulnerabilities
for repository in "${repositories[@]}"; do
    url="https://api.github.com/repos/$repository/dependabot/alerts?severity=critical&state=open"
    vulnerabilities=$(curl -s -H "Authorization: token $GITHUB_ARGOS_TOKEN" "$url" | jq -r ". | length")
    total_vulnerabilities=$((total_vulnerabilities + vulnerabilities))
done

# Print the total number of pull requests
if [ "$total_vulnerabilities" -gt 0 ]; then
    echo "$total_vulnerabilities :robot:"
else
    echo "---"
fi

echo "---"
echo "View Vulnerabilities | href=https://github.com/surfly/cobro/security/dependabot?q=is%3Aopen+severity%3Acritical"
