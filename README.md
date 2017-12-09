# Packer Images
Packer Image Templates and Scripts

## Base Images
Available in following Linux distributions

1. RedHat
2. Centos
3. Ubuntu
4. Debian

## Application Images
1. Rancher

## Build Image

### Build AMI

To build a centos AMI run the following command

```
make build-ami OS=centos OS_VERSION=7 TYPE=base VAR_FILE=some/path.json CLOUD_INIT_FILE=some/other/path
```

Supported options for parameters are
`OS values` are centos, rhel, debian, ubuntu.
`OS_VERSION` for centos are 7
`OS_VERSION` for rhel are 7
`OS_VERSION` for debian are jessie
`OS_VERSION` for ubuntu are 17.04

Supported parameters in var file are

| Parameter Name       | Description                                                                                                   |
| `AWS_AMI_NAME`       | Name of the ami to use to build our ami (Mandatory)                                                           |
| `AWS_SECURITY_GROUP` | Default security group to apply for packer build instance. If not supplied, packer will generate one and use. |
| `AWS_SUBNET_ID`      | Subnet to create the packer instance. (Mandatory)                                                             |
| `HTTP_PROXY`         | http proxy to use for packer instance to connect to external world                                            |
| `HTTPS_PROXY`        | https proxy to use for packer instance to connect to external world                                           |
| `NO_PROXY`           | no proxy to use for packer instance                                                                           |
|                      |                                                                                                               |
Sample Var file
```
{

}
```
