# Load parameters from the .env file
set -a
source ../.env
set +a

echo "ai_services"
az cognitiveservices account keys list --name "$SERVICE_NAME" --resource-group "$RESOURCE_GROUP"

az cognitiveservices account show \
  --name "$SERVICE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "properties.endpoint" \
  --output tsv

echo "ai_search"
az search admin-key show --service-name "$SERVICE_AI_SEARCH_NAME" --resource-group "$RESOURCE_GROUP"

az search service show \
  --name "$SERVICE_AI_SEARCH_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --subscription "f1e6ca4e-bfe7-4906-ba40-7fbd8c9dfefa" \
  --query "properties.endpoint" \
  --output tsv