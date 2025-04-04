#!/bin/bash

# Define the .env file path
ENV_FILE=".env"

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: $ENV_FILE not found!"
    exit 1
fi

echo "🔄 Loading environment variables from $ENV_FILE..."

# Read and export variables from .env
while IFS='=' read -r key value || [ -n "$key" ]; do
    # Ignore comments and empty lines
    if [[ "$key" =~ ^#.*$ ]] || [[ -z "$key" ]]; then
        continue
    fi

    # Remove possible quotes around values
    value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//')

    # Export the variable
    export "$key=$value"

    echo "Loaded: $key=$value"
done < "$ENV_FILE"

echo "🚀 All environment variables set!"
