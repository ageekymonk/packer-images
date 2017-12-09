SHELL 	:=/bin/bash
DIR			:=$(shell pwd)

## Set the Default variables
CLOUD 			:= aws
OS					:= centos
OS_VERSION 	:= 7
TYPE				:= base


ANSIBLE_REPO := https://github.com/cloud-bootstrap/ansible-playbooks.git
ANSIBLE_REPO_BRANCH := master
ANSIBLE_PLAYBOOK := $(TYPE)

PACKER_CONFIG_DIR :=

ifneq ($(wildcard $(PACKER_CONFIG_DIR)/cloudinit/$(OS)-$(OS_VERSION)),)
CLOUD_INIT_FILE = $(PACKER_CONFIG_DIR)/cloudinit/$(OS)-$(OS_VERSION)
else
CLOUD_INIT_FILE := cloudinit/$(OS)-$(OS_VERSION)
endif

ifneq ($(wildcard $(PACKER_CONFIG_DIR)/configs/$(CLOUD)/$(OS)-$(OS_VERSION).json),)
VAR_FILE = $(PACKER_CONFIG_DIR)/configs/$(CLOUD)/$(OS)-$(OS_VERSION).json
else
$(error VAR_FILE is not set)
endif

ifneq ($(wildcard $(PACKER_CONFIG_DIR)/certs/.*),)
CERTS_DIR = $(PACKER_CONFIG_DIR)/certs
endif

.PHONY: build

dep:: ## Download all dependencies
	@echo "Updating all dependencies"
ifneq ($(wildcard ansible-playbooks/.*),)
	@cd ansible-playbooks && git pull -q
else
	@echo "cloning ansible repo"
	@git clone -b $(ANSIBLE_REPO_BRANCH) $(ANSIBLE_REPO)
endif

build-ami:: dep ## Build Packer Image.
	@echo "Building $(OS)-$(OS_VERSION)-$(TYPE)"
	@echo "TODO: Merge json var file"
	@packer build -var-file $(VAR_FILE) 				\
		-var "os_version=$(OS_VERSION)" 					\
		-var "os=$(OS)"													 	\
		-var "image_type=$(TYPE)" 								\
		-var "playbook=$(ANSIBLE_PLAYBOOK)" 			\
		-var "user_data_file=$(CLOUD_INIT_FILE)" 	\
		-var "certs_dir=$(CERTS_DIR)" 						\
		templates/aws/$(OS)-$(TYPE).json

# A help target including self-documenting targets (see the awk statement)
help: ## This help target
	$(logo)
	@echo "Build Packer Image for aws. "
	@echo "Mandatory Params are OS={centos,ubuntu}, TYPE={base}"
	@echo "$$HELP_TEXT"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)
