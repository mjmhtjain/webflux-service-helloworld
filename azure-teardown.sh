#!/bin/bash
set -e

AZ_RESOURCE_GROUP=webfluxapiservice

# destroy resource group.
az group delete \
    --name $AZ_RESOURCE_GROUP \
    --yes

