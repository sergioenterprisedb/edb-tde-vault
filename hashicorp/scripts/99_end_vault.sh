#!/bin/bash

PROCESS_NAME="vault"

# Find the PID of the Vault process
PID=$(pgrep -f "$PROCESS_NAME")

# Check if the PID was found
if [ -z "$PID" ]; then
  echo "No Vault process found."
  exit 1
fi

# Terminate the Vault process
echo "Killing Vault process with PID $PID..."
kill $PID

# Check if the process was successfully terminated
if [ $? -eq 0 ]; then
  echo "Vault process terminated successfully."
else
  echo "Failed to terminate Vault process."
  exit 2
fi

