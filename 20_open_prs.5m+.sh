#!/usr/bin/env bash

# Set the GitHub username
username="jsnjack"

# Define the repositories to check
repositories=(
    "surfly/cobro"
    "surfly/deployment"
    "surfly/install"
    "surfly/ci"
)

# Initialize the total number of pull requests to 0
total_pull_requests=0

# Loop through the repositories and add up the number of pending pull request reviews for the specified user
for repository in "${repositories[@]}"; do
    pull_requests=$(curl -s -H "Authorization: token $GITHUB_ARGOS_TOKEN" "https://api.github.com/repos/$repository/pulls?state=open" | jq --arg username "$username" '.[] | select(.draft == false) | select(.requested_reviewers[].login == $username) | .number' | wc -l)
    total_pull_requests=$((total_pull_requests + pull_requests))
done

if [ "$total_pull_requests" -gt 0 ]; then
    echo "$total_pull_requests :hammer:"
else
    echo ":palm_tree:"
fi

echo "---"
echo "View Pull Requests | href=https://github.com/pulls/review-requested"
