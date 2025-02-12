#!/bin/bash

# Load parameters from the .env file
set -a
source .env
set +a
#Login
az login

# Create the Azure AI Services resource
az cognitiveservices account create \
    --name "$SERVICE_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --kind "$KIND" \
    --sku "$PRICING_TIER" \
    --location "$LOCATION" \
    --custom-domain $SERVICE_NAME \
    

source /azure_commands/retrieve_keys_endpoint.sh

# Create a resource group (if not exists)
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"