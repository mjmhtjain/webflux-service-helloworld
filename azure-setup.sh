#!/bin/bash
set -e

AZ_RESOURCE_GROUP=webfluxapiservice
AZ_LOCATION=eastus
AZ_ACR=webfluxapiserviceregistry
ACR_LOGIN_SERVER=webfluxapiserviceregistry
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

ACR_LOGIN_SERVER=$(az acr list \
  --resource-group $AZ_RESOURCE_GROUP \
  | jq -r '.[0].loginServer')

# login to registry
AZ_ACR_PASSWORD=$(az acr credential show \
  --resource-group $AZ_RESOURCE_GROUP \
  --name $AZ_ACR | jq -r '.passwords[0].value')

# build docker image
docker build --tag $DOCKER_IMAGE_TAG .
docker tag $DOCKER_IMAGE_TAG $ACR_LOGIN_SERVER/$DOCKER_IMAGE_TAG:latest

# push image to ACR
echo $AZ_ACR_PASSWORD | docker login $ACR_LOGIN_SERVER \
  --username $AZ_ACR \
  --password-stdin

docker push $ACR_LOGIN_SERVER/$DOCKER_IMAGE_TAG:latest

# show repo list of images
# az acr repository list -n $AZ_ACR

# create AKS cluster
az aks create \
  --resource-group=$AZ_RESOURCE_GROUP \
  --name=$AZ_AKS \
  --vm-set-type VirtualMachineScaleSets \
  --enable-cluster-autoscaler \
  --min-count 3 \
  --max-count 5 \
  --attach-acr $AZ_ACR \
  --dns-name-prefix=$AZ_DNS_PREFIX \
  --generate-ssh-keys \
  --load-balancer-sku standard

az aks get-credentials \
  --resource-group=$AZ_RESOURCE_GROUP \
  --name=$AZ_AKS \
  --overwrite-existing

# deploy image to AKS instance
# kubectl get services -o=jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}'

kubectl apply -f azure-aks-deployment.yaml

kubectl get services --watch

# az aks scale --resource-group $AZ_RESOURCE_GROUP --name $AZ_AKS --node-count 3

# az aks show --name $AZ_AKS --resource-group $AZ_RESOURCE_GROUP