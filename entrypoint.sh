#!/bin/sh

API_VERSION=2020-06-30

set -e

if [ -z "$INPUT_AZURESEARCHINSTANCE" ]; then
  echo "azureSearchInstance is not set."
  exit 1
fi

if [ -z "$INPUT_AZURESEARCHADMINKEY" ]; then
  echo "azureSearchAdminKey is not set."
  exit 1
fi

if [ -z "$INPUT_INDEXNAME" ]; then
  echo "indexName is not set."
  exit 1
fi

if [ ! -z "$INPUT_INDEXDEFINITIONFILE" ]; then
  echo "Using local definition file."
  DEFINITION_IS_LOCAL=true
  DEFINITION_LOCATION=$INPUT_INDEXDEFINITIONFILE
fi

if [ ! -z "$INPUT_INDEXDEFINITIONURI" ]; then
  echo "Using remote definition file."
  DEFINITION_IS_LOCAL=false
  DEFINITION_LOCATION=$INPUT_INDEXDEFINITIONURI
fi

if [ -z "$DEFINITION_LOCATION" ]; then
  echo "Defintion location could not be determined.  Supply one of indexDefinitionFile or indexDefinitionUri"
  exit 1
fi

if test "$DEFINITION_IS_LOCAL" = true; then
  if [ -f $DEFINITION_LOCATION ]; then
    DEFINITION=$(cat $DEFINITION_LOCATION)
    if test "$?" != "0"; then
      echo "Unable to read definition file!"
      exit 1
    fi
  else
    echo "Cannot find definition file '$DEFINITION_LOCATION'"
    exit 1
  fi
else
  echo "Downloading definition file: ${DEFINITION_LOCATION}..."
  DEFINITION=$(curl --fail-with-body -sSD/dev/stderr $DEFINITION_LOCATION)
  if test "$?" != "0"; then
    echo "the curl command failed with: $?"
    exit 1
  fi
fi

echo "Updating index on instance '${INPUT_AZURESEARCHINSTANCE}':"
echo $DEFINITION | jq

set +e
RESPONSE=$(curl --fail-with-body -sSD/dev/stderr \
  --location \
  --request PUT "https://${INPUT_AZURESEARCHINSTANCE}.search.windows.net/indexes/${INPUT_INDEXNAME}?api-version=${API_VERSION}" \
  --header 'content-type: application/json' \
  --header "api-key: ${INPUT_AZURESEARCHADMINKEY}" \
  --data-raw "$DEFINITION")

CURL_EXIT_CODE="$?"
set -e
echo $RESPONSE | jq

if test "$CURL_EXIT_CODE" != "0"; then
  exit 1
fi