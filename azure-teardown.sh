#!/bin/bash
set -e

AZ_RESOURCE_GROUP=webfluxapiservice

# destroy resource group.
az group delete \
    --name $AZ_RESOURCE_GROUP \
    --yes

AZ_RESOURCE_GROUP=$(az network watcher list | jq -r '.[0].resourceGroup')

az group delete \
    --name $AZ_RESOURCE_GROUP \
    --yes