PYTHON_VERSION := 3.8.2
ALPINE_VERSION := 3.11

GIT_REPO := github.com/michalswi/flask-health
DOCKER_REPO := michalsw

APPNAME ?= flaskhz
VERSION ?= $(shell git describe --tags --always 2>/dev/null || echo testdev)

SERVER_PORT ?= 8080

AZ_RG ?= flaskhz
AZ_PORT ?= 80
AZ_LOCATION ?= westeurope
AZ_RANDOM ?=$(shell head /dev/urandom | tr -dc a-z0-9 | head -c 7)
AZ_DNS_LABEL ?= $(APPNAME)-$(AZ_RANDOM)

.DEFAULT_GOAL := help
.PHONY: help docker-build docker-run docker-stop az-rg az-rg-del az-aci az-aci-fqdn az-aci-logs az-aci-delete

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ \
	{ printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

docker-build: ## Build docker image
	docker build \
	--pull \
	--build-arg PYTHON_VERSION="$(PYTHON_VERSION)" \
	--build-arg ALPINE_VERSION="$(ALPINE_VERSION)" \
	--label="build.version=$(VERSION)" \
	--tag="$(DOCKER_REPO)/$(APPNAME):latest" \
	.

docker-run: ## Run docker
	docker run --rm -d \
	-p $(SERVER_PORT):$(SERVER_PORT) \
	--name $(APPNAME) $(APPNAME):latest && \
	docker ps

docker-stop: ## Stop docker
	docker stop $(APPNAME)

az-rg:	## Create the Azure Resource Group (az login first)
	az group create --name $(AZ_RG) --location $(AZ_LOCATION)

az-rg-del:	## Delete the Azure Resource Group
	az group delete --name $(AZ_RG)

az-aci:	## Run app (Azure Container Instance)
	az container create \
	--resource-group $(AZ_RG) \
	--name $(APPNAME) \
	--image michalsw/$(APPNAME) \
	--restart-policy Always \
	--ports $(AZ_PORT) \
	--dns-name-label $(AZ_DNS_LABEL) \
	--location $(AZ_LOCATION) \
	--environment-variables \
		SERVER_PORT=$(AZ_PORT)

az-aci-fqdn: ## Get app FQDN
	az container list \
	--resource-group $(AZ_RG) \
	--query "[].ipAddress.fqdn" -o tsv

az-aci-logs:	## Get app logs (Azure Container Instance)
	az container logs \
	--resource-group $(AZ_RG) \
	--name $(APPNAME)

az-aci-delete:	## Delete app (Azure Container Instance)
	az container delete \
	--resource-group $(AZ_RG) \
	--name $(APPNAME)