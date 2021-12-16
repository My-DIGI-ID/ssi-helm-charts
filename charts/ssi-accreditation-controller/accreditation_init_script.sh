#! /bin/bash
mkdir -p ./.indy_client
echo "Connecting to ${AGENT_URL}"
echo "AGENT_API_KEY: ${AGENT_API_KEY}"
echo "EMPLOYEE_CREDENTIAL_SCHEMA: ${EMPLOYEE_CREDENTIAL_SCHEMA}"
echo "EMPLOYEE_CREDENTIAL_NAME: ${EMPLOYEE_CREDENTIAL_NAME}"
echo "GUEST_CREDENTIAL_SCHEMA: ${GUEST_CREDENTIAL_SCHEMA}"
echo "GUEST_CREDENTIAL_NAME: ${GUEST_CREDENTIAL_NAME}"
echo ""

if [ ! -e EMPLOYEE_CREDENTIAL_DEFINITION_ID ]; then
  echo "Creating employee credential definition"
  curl -X POST "${AGENT_URL}/credential-definitions" \
    -H "X-Api-Key: $AGENT_API_KEY" \
    -H "accept: application/json" \
    -H "Content-Type: application/json" \
    -d "{  \"revocation_registry_size\": 1000,  \"schema_id\": \"$EMPLOYEE_CREDENTIAL_SCHEMA\",  \"support_revocation\": true,  \"tag\": \"$EMPLOYEE_CREDENTIAL_NAME\"}" | jq '.credential_definition_id' | sed 's/"//g' > ./.indy_client/EMPLOYEE_CREDENTIAL_DEFINITION_ID
  echo "Employee credential definition ID: $(cat ./.indy_client/EMPLOYEE_CREDENTIAL_DEFINITION_ID)"
fi

if [ ! -e EMPLOYEE_REVOCATION_REGISTRY_ID ]; then
  echo "Create employee revocation registry"
  curl -X POST "${AGENT_URL}/revocation/create-registry" \
    -H "X-Api-Key: $AGENT_API_KEY" \
    -H "accept: application/json" \
    -H "Content-Type: application/json" \
    -d "{  \"credential_definition_id\": \"$(cat ./.indy_client/EMPLOYEE_CREDENTIAL_DEFINITION_ID)\",  \"max_cred_num\": 1000}" | jq '.result' | jq '.revoc_reg_id' | sed 's/"//g' > ./.indy_client/EMPLOYEE_REVOCATION_REGISTRY_ID
  echo "Employee revocation registry ID: $(cat ./.indy_client/EMPLOYEE_REVOCATION_REGISTRY_ID)"
fi

if [ ! -e GUEST_CREDENTIAL_DEFINITION_ID ]; then
  echo "Creating guest credential definition"
  curl -X POST "${AGENT_URL}/credential-definitions" \
    -H "X-Api-Key: $AGENT_API_KEY" \
    -H "accept: application/json" \
    -H "Content-Type: application/json" \
    -d "{  \"revocation_registry_size\": 1000,  \"schema_id\": \"$GUEST_CREDENTIAL_SCHEMA\",  \"support_revocation\": true,  \"tag\": \"$GUEST_CREDENTIAL_NAME\"}" | jq '.credential_definition_id' | sed 's/"//g' > ./.indy_client/GUEST_CREDENTIAL_DEFINITION_ID
  echo "Guest credential definition ID: $(cat ./.indy_client/GUEST_CREDENTIAL_DEFINITION_ID)"
fi

if [ ! -e GUEST_REVOCATION_REGISTRY_ID ]; then
  echo "Create guest revocation registry"
  curl -X POST "${AGENT_URL}/revocation/create-registry" \
    -H "X-Api-Key: $AGENT_API_KEY" \
    -H "accept: application/json" \
    -H "Content-Type: application/json" \
    -d "{  \"credential_definition_id\": \"$(cat ./.indy_client/GUEST_CREDENTIAL_DEFINITION_ID)\",  \"max_cred_num\": 1000}" | jq '.result' | jq '.revoc_reg_id' | sed 's/"//g' > ./.indy_client/GUEST_REVOCATION_REGISTRY_ID
  echo "Guest revocation registry ID: $(cat ./.indy_client/GUEST_REVOCATION_REGISTRY_ID)"
fi