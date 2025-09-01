#!/bin/bash
set -e

URL="https://dev-oneclickbouquet.sctp-sandbox.com/"

echo "Testing $URL for HTTP 200 status..."

HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" $URL)

if [ "$HTTP_STATUS" -eq 200 ]; then
  echo "Success: Received HTTP 200"
  exit 0
else
  echo "Failure: Expected HTTP 200 but got $HTTP_STATUS"
  exit 1
fi
