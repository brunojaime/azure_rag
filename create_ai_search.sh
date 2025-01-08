#!/bin/bash

# Load parameters from the .env file
set -a
source .env
set +a


# Create the Azure AI SEARCH SERVICE
az search service create \
    --name "$SERVICE_AI_SEARCH_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --sku "$SKU_SEARCH" \
    --location "$LOCATION" \
    --partition-count "$PARTITION_COUNT" \
    --replica-count "$REPLICA_COUNT"

ENDPOINT=$(az search service show \
  --name "$SERVICE_AI_SEARCH_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "properties.hostName" \
  --output tsv)

echo "Service Endpoint: https://$ENDPOINT"