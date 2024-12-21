#!/bin/bash

# Load parameters from the .env file
set -a
source parameters.env
set +a

# Create the Chat Deployment
az cognitiveservices account deployment create \
    --name $SERVICE_NAME \
    --resource-group $RESOURCE_GROUP \
    --deployment-name $CHAT_DEPLOYMENT_NAME \
    --model-name $CHAT_MODEL_NAME \
    --model-version "$CHAT_MODEL_VERSION" \
    --model-format $CHAT_MODEL_FORMAT \
    --sku-capacity "$CHAT_SKU_CAPACITY" \
    --sku-name $CHAT_SKU_NAME \
    
# Create the Embedded Deployment
az cognitiveservices account deployment create \
    --name $SERVICE_NAME \
    --resource-group $RESOURCE_GROUP \
    --deployment-name $EMBEDDING_DEPLOYMENT_NAME \
    --model-name $EMBEDDING_MODEL_NAME \
    --model-version "$EMBEDDING_MODEL_VERSION" \
    --model-format $EMBEDDING_MODEL_FORMAT \
    --sku-capacity "$EMBEDDING_SKU_CAPACITY" \
    --sku-name "$EMBEDDING_SKU_NAME" \

# Create hub
az ml workspace create --kind hub -g $RESOURCE_GROUP -n hub-demo
