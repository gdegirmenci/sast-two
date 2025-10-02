#!/usr/bin/env python3
"""
Python application with intentional security issues for SAST detection
"""

import os
import hashlib

# Issue 1: Hardcoded credentials
DATABASE_PASSWORD = "MySecretPassword123!"
API_KEY = "sk-1234567890abcdefghijklmnopqrstuvwxyz"
AWS_SECRET_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

# Issue 2: Hardcoded database connection string
DATABASE_URL = "postgresql://admin:password123@db.example.com:5432/mydb"

# Issue 3: AWS credentials
AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE"

# Issue 4: Private key (partial example)
PRIVATE_KEY = """-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA1234567890example
-----END RSA PRIVATE KEY-----"""

# Issue 5: JWT secret
JWT_SECRET = "super-secret-jwt-key-that-should-not-be-hardcoded"

# Issue 6: Slack webhook
SLACK_WEBHOOK = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXX"

# Issue 7: GitHub token
GITHUB_TOKEN = "ghp_1234567890abcdefghijklmnopqrstuvwxyz"

# Issue 8: Generic API token
API_TOKEN = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

# Issue 9: Email credentials
EMAIL_PASSWORD = "email_password_123"
SMTP_HOST = "smtp.gmail.com"
SMTP_USER = "user@example.com"

# Issue 10: Encryption key
ENCRYPTION_KEY = "0123456789abcdef0123456789abcdef"

def connect_to_database():
    """Connect to database using hardcoded credentials"""
    # This would connect using DATABASE_PASSWORD and DATABASE_URL
    print(f"Connecting to {DATABASE_URL}")
    pass

def call_api():
    """Call external API using hardcoded API key"""
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "X-API-Key": API_TOKEN
    }
    # This would make an API call
    pass

def use_aws_credentials():
    """Use AWS with hardcoded credentials"""
    # Issue: Using hardcoded AWS credentials
    os.environ['AWS_ACCESS_KEY_ID'] = AWS_ACCESS_KEY_ID
    os.environ['AWS_SECRET_ACCESS_KEY'] = AWS_SECRET_KEY
    pass

if __name__ == "__main__":
    connect_to_database()
    call_api()
    use_aws_credentials()
    print("Application started with hardcoded secrets!")
