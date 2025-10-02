#!/bin/bash
# Deployment script with intentional security issues for SAST detection

# Issue 1: Hardcoded credentials
export DB_PASSWORD="MyDatabasePassword123"
export API_KEY="1234567890abcdefghijklmnopqrstuvwxyz"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"

# Issue 2: Hardcoded tokens
GITHUB_TOKEN="ghp_abcdefghijklmnopqrstuvwxyz1234567890"
DOCKER_PASSWORD="MyDockerHubPassword123"

# Issue 3: Private SSH key path with credentials
SSH_PRIVATE_KEY="/home/user/.ssh/id_rsa_with_password_12345"

# Issue 4: Database connection string with credentials
DATABASE_URL="mysql://root:password@localhost:3306/mydb"

# Issue 5: Using credentials in commands
echo "Connecting to database with password: $DB_PASSWORD"

# Issue 6: Docker login with exposed credentials
docker login -u admin -p "$DOCKER_PASSWORD" docker.io

# Issue 7: Git clone with embedded credentials
git clone https://user:password123@github.com/myorg/myrepo.git

# Issue 8: AWS CLI with hardcoded credentials
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY

# Issue 9: Curl with API key in URL
curl -X GET "https://api.example.com/data?api_key=$API_KEY"

# Issue 10: Slack webhook
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXX"
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"Deployment completed"}' \
  $SLACK_WEBHOOK_URL

echo "Deployment script completed with hardcoded secrets!"
