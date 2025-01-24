#!/bin/bash

# Variables
USERNAME="hmac-auth-user"
SECRET="boat"
ALGORITHM="hmac-sha256"
HTTP_METHOD="GET"
REQUEST_PATH="/hmac_auth/protected"
HOST="api.erichsen.dev"

# Generate the current RFC 1123 formatted date (e.g., Thu, 23 Jan 2025 12:00:00 GMT)
DATE=$(date -u +"%a, %d %b %Y %H:%M:%S GMT")

# Convert HTTP method to lowercase (for compatibility across Bash versions)
HTTP_METHOD_LOWER=$(echo "$HTTP_METHOD" | tr '[:upper:]' '[:lower:]')

# Create the string to sign (matching headers="date @request-target")
STRING_TO_SIGN="date: ${DATE}
@request-target: ${HTTP_METHOD_LOWER} ${REQUEST_PATH}"

# Generate HMAC-SHA256 signature and base64 encode it
SIGNATURE=$(echo -n "$STRING_TO_SIGN" | openssl dgst -sha256 -hmac "$SECRET" -binary | base64)

# Construct the Authorization header
AUTH_HEADER="hmac username=\"${USERNAME}\", algorithm=\"${ALGORITHM}\", headers=\"date @request-target\", signature=\"${SIGNATURE}\""

# Make the HTTP request with curl
curl -X ${HTTP_METHOD} "https://${HOST}${REQUEST_PATH}" \
  -H "Date: ${DATE}" \
  -H "Authorization: ${AUTH_HEADER}"
