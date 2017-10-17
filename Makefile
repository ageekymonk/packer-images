SHELL := /bin/bash
ROOT_DIR 	:= $(shell pwd)
TIME 	:= $(shell date '+%Y-%m-%dT%T%z')
HASH 	:= $(shell git rev-parse --verify --short HEAD || echo "")
USER 	:= $(shell echo $$(whoami))

.PHONY: help

base: ## Build base image
	@echo "Building $(OS) Base image for $(CLOUD)"

# Uncomment the following line for logo
# define logo
# @cat data/logo.ascii
# endef

# A help target including self-documenting targets (see the awk statement)
help: ## Print Help
	$(logo)
	@echo "$$HELP_TEXT"
	@echo "variables:"
	@echo "  OS = {RH, CENTOS, UBUNTU, DEBIAN}"
	@echo "  CLOUD = {AWS, AZURE, GCP, VMWARE}"
	@echo "  BUILDER = {QEMU}"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)
