PYTHON_VERSION := 3.8.2
ALPINE_VERSION := 3.11

APPNAME ?= flaskhz
SERVER_PORT ?= 8080

VERSION ?= $(shell git describe --tags --always 2>/dev/null || echo testdev)

.DEFAULT_GOAL := help
.PHONY: help docker-build docker-run docker-stop

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ \
	{ printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

docker-build: ## Build docker image
	docker build \
	--pull \
	--build-arg PYTHON_VERSION="$(PYTHON_VERSION)" \
	--build-arg ALPINE_VERSION="$(ALPINE_VERSION)" \
	--label="build.version=$(VERSION)" \
	--tag="$(APPNAME):latest" \
	.

docker-run: ## Run docker
	docker run --rm -d \
	-p $(SERVER_PORT):$(SERVER_PORT) \
	--name $(APPNAME) $(APPNAME):latest && \
	docker ps

docker-stop: ## Stop docker
	docker stop $(APPNAME)
