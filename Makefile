SHELL 	:=/bin/bash
DIR			:=$(shell pwd)
PROXY		:=

OS					:= centos
OS_VERSION 	:= 7
TYPE				:= base

ifeq ($(OS),centos)
	AWS_CENTOS_SSH_USERNAME ?= centos
	AWS_CENTOS_SOURCE_AMI ?= ami-24959b47
endif

ifeq ($(OS), ubuntu)
ifeq ($(OS_VERSION), 17.04)
	AWS_UBUNTU_SSH_USERNAME ?= ubuntu
	AWS_UBUNTU_SOURCE_AMI ?= ami-10ca2172
endif
endif

.PHONY: build

dep:: ## Download all dependencies
ifneq ($(wildcard ansible-playbooks/.*),)
	@cd ansible-playbooks && git pull
else
	@echo "cloning ansible repo"
	@git clone https://github.com/cloud-bootstrap/ansible-playbooks.git
endif

build-ami:: dep ## Build Packer Image.
	@echo "Building $(OS)-$(OS_VERSION)-$(TYPE) in subnet $(AWS_SUBNET_ID)"
	@packer build \
		-var "source_ami=$(AWS_CENTOS_SOURCE_AMI)" 						\
		-var "subnet_id=$(AWS_SUBNET_ID)" 										\
		-var "ssh_username=$(AWS_CENTOS_SSH_USERNAME)" 				\
		-var "ssh_keypair_name=$(AWS_SSH_KEYPAIR_NAME)" 			\
		-var "ssh_private_key_file=$(SSH_PRIVATE_KEY_FILE)" 	\
		-var "image_type=$(TYPE)"															\
		-var "os_version=$(OS_VERSION)"												\
		-var "playbook=$(TYPE)"												        \
		-var "proxy=$(PROXY)"																	\
		templates/aws/$(OS)-$(TYPE).json

# A help target including self-documenting targets (see the awk statement)
help: ## This help target
	$(logo)
	@echo "Build Packer Image for aws. "
	@echo "Mandatory Params are OS={centos,ubuntu}, TYPE={base}"
	@echo "$$HELP_TEXT"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)
