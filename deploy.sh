#!/bin/bash

# Hardcoded credentials
# CKV_SECRET: Hardcoded AWS credentials
AWS_ACCESS_KEY="AKIAIOSFODNN7EXAMPLE"
AWS_SECRET_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
DB_PASSWORD="MyS3cr3tP@ssw0rd"

# Command injection vulnerability
# CKV_COMMAND_INJECTION: Unsanitized variable in command
BRANCH_NAME=$1
git checkout $BRANCH_NAME

# Using curl without certificate verification
# CKV_INSECURE_SSL: Disabling SSL verification
curl -k https://api.example.com/deploy

# Wget without certificate verification
wget --no-check-certificate https://downloads.example.com/package.tar.gz

# Overly permissive file permissions
# CKV_PERMISSIONS: Setting world-writable permissions
chmod 777 /var/www/config.ini
chmod 666 /etc/app/secrets.json

# Running as root without dropping privileges
# CKV_ROOT_USER: Running critical operations as root
if [ "$EUID" -eq 0 ]; then
  echo "Running deployment as root"
  ./install.sh
fi

# Logging sensitive data
# CKV_LOG_SENSITIVE: Logging credentials
echo "Deploying with credentials: $AWS_ACCESS_KEY:$AWS_SECRET_KEY" >> deploy.log

# Using eval with user input (from environment)
# CKV_CODE_INJECTION: Using eval with potentially untrusted input
CUSTOM_COMMAND=$2
eval $CUSTOM_COMMAND

# Insecure temporary file creation
# CKV_INSECURE_TEMP: Predictable temp file name
TEMP_FILE="/tmp/deploy_config.txt"
echo "CONFIG_KEY=$DB_PASSWORD" > $TEMP_FILE

echo "Deployment complete"
