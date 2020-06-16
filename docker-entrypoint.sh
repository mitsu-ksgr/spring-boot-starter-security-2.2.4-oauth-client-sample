#!/bin/bash
#
# docker-entrypoint.sh
#
set -e

PROJ_DIR=/app
cd ${PROJ_DIR}

# Setup hosts
DOCKER_HOST=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}')
echo "${DOCKER_HOST} dockerhost" >> /etc/hosts

# Generate certificates
./generate_certificates.sh /app/certs

# Build Application
./gradlew clean build

# Run the application.
java -jar ./build/libs/*.jar

