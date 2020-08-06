# Kunlun
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/scaat/kunlun/blob/master/LICENSE)


Kunlun is a dynamic, high-performance API Gateway. Provides rich traffic management features such as load balancing, dynamic upstream, canary release, circuit breaking, authentication, observability, and more.

## To start using Kunlun

### CentOS 7

> Install OpenResty and other required dependencies.

```shell
# Add OpenResty Repo
sudo yum -y install yum-utils
sudo yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo

# Install OpenResty
sudo yum -y install openresty-1.17.8.2-1.el7
```
