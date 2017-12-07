# Packer Images
Packer Image Templates and Scripts

## Base Images
Available in following linux distributions

1. RedHat
2. Centos
3. Ubuntu
4. Debian

## Application Images
1. Rancher


## Build Image

### Build AMI

Builds an AMI in the given subnet.
```
make build-ami OS=centos AWS_SUBNET_ID=subnet-xxx AWS_SSH_KEYPAIR_NAME=cloudbootstrap SSH_PRIVATE_KEY_FILE=cloudbootstrap.pem
```

You can use the following variables to customize.

```
OS
OS_VERSION
TYPE
AWS_SUBNET_ID
PROXY
SSH_PRIVATE_KEY_FILE
AWS_CENTOS_SOURCE_AMI
AWS_CENTOS_SSH_USERNAME
AWS_UBUNTU_SOURCE_AMI
AWS_UBUNTU_SSH_USERNAME
```
