#!/bin/bash
set -e

AZ_RESOURCE_GROUP=webfluxapiservice
AZ_LOCATION=eastus
AZ_ACR=webfluxapiserviceregistry
AZ_ACR_PASSWORD=password
DOCKER_IMAGE_TAG=webfluxbasicapi
AZ_AKS=webfluxapiservice-akscluster
AZ_DNS_PREFIX=webfluxapiservice-kubernetes
AKS_POD=webfluxbasicapi-pod

# Create a resource group.
az group create \
    --name $AZ_RESOURCE_GROUP \
    --location $AZ_LOCATION \
    | jq

# Create a registry
az acr create --resource-group $AZ_RESOURCE_GROUP \
  --location $AZ_LOCATION \
  --name $AZ_ACR \
  --sku Basic \
  --admin-enabled true

# login to registry
AZ_ACR_PASSWORD=$(az acr credential show --resource-group $AZ_RESOURCE_GROUP \
--name $AZ_ACR | jq -r '.passwords[0].value')

# build docker image
docker build --tag $DOCKER_IMAGE_TAG .
docker tag $DOCKER_IMAGE_TAG $AZ_ACR.azurecr.io/$DOCKER_IMAGE_TAG:latest

# push image to ACR
docker login $AZ_ACR.azurecr.io --username $AZ_ACR --password $AZ_ACR_PASSWORD
docker push $AZ_ACR.azurecr.io/$DOCKER_IMAGE_TAG:latest

# show repo list of images
az acr repository list -n $AZ_ACR

# create AKS cluster
az aks create --resource-group=$AZ_RESOURCE_GROUP \
  --name=$AZ_AKS \
  --attach-acr $AZ_ACR \
  --dns-name-prefix=$AZ_DNS_PREFIX \
  --generate-ssh-keys

az aks get-credentials --resource-group=$AZ_RESOURCE_GROUP \
  --name=$AZ_AKS

# deploy image to AKS instance
kubectl run $AKS_POD --image=$AZ_ACR.azurecr.io/$DOCKER_IMAGE_TAG:latest
kubectl expose pod $AKS_POD --type=LoadBalancer --port=80 --target-port=8080
kubectl get services -o=jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}'

# AKS web interface
az aks browse --resource-group=$AZ_RESOURCE_GROUP \
  --name=$AZ_AKS