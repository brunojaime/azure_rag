#!/bin/bash

# Load parameters from the .env file
set -a
source .env
set +a



# Create the Azure Storage Account
az storage account create  \
    --name "$STORAGE_ACCOUNT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --sku "$STORAGE_SKU" \
    --kind "$STORAGE_KIND"

# Retrieve the primary endpoint of the storage account
PRIMARY_ENDPOINT=$(az storage account show \
    --name "$STORAGE_ACCOUNT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "primaryEndpoints.blob" \
    --output tsv)

echo "Primary Blob Service Endpoint: $PRIMARY_ENDPOINT"

az cognitiveservices account deployment create \
    --name "$SERVICE_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --deployment-name "$CHAT_DEPLOYMENT_NAME" \
    --model-name "$CHAT_MODEL_NAME" \
    --model-version "$CHAT_MODEL_VERSION" \
    --model-format "$CHAT_MODEL_FORMAT" \
    --sku-capacity "$CHAT_SKU_CAPACITY" \
    --sku-name "$CHAT_SKU_NAME" \