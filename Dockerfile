# Dockerfile with intentional security issues for Checkov detection

# Issue 1: Using 'latest' tag instead of specific version
FROM ubuntu:latest

# Issue 2: Running as root user (no USER directive)
# Issue 3: Installing packages without cleaning up
RUN apt-get update && \
    apt-get install -y curl wget git

# Issue 4: Hardcoded secrets
ENV API_KEY="sk-1234567890abcdefghijklmnopqrstuvwxyz"
ENV DB_PASSWORD="MySecretPassword123"

# Issue 5: Exposing sensitive ports
EXPOSE 22
EXPOSE 3389
EXPOSE 23

# Issue 6: Adding potentially sensitive files
COPY . /app

WORKDIR /app

# Issue 7: Using ADD instead of COPY for local files
ADD config.tar.gz /config/

# Issue 8: Not using HEALTHCHECK
# (Missing HEALTHCHECK directive)

# Issue 9: Running with elevated privileges (would need --privileged flag)
# Issue 10: No specific USER set - running as root
CMD ["/bin/bash"]
