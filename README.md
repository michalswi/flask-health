# Simple Flask App

```
$ make

Usage:
  make <target>

Targets:
  docker-build     Build docker image
  docker-run       Run docker
  docker-stop      Stop docker
  az-rg            Create the Azure Resource Group (az login first)
  az-rg-del        Delete the Azure Resource Group
  az-aci           Run app (Azure Container Instance)
  az-aci-fqdn      Get app FQDN
  az-aci-logs      Get app logs (Azure Container Instance)
  az-aci-delete    Delete app (Azure Container Instance)
```

### \# Azure ACI

```
az login

make az-rg
make az-aci

$ > it might take few minutes

$ make az-aci-fqdn
flaskhz-7tb8u1d.westeurope.azurecontainer.io

$ curl http://flaskhz-7tb8u1d.westeurope.azurecontainer.io:8080/hz
OK

$ curl http://flaskhz-7tb8u1d.westeurope.azurecontainer.io:8080
hello world

$ make az-aci-logs
(...)
10.92.0.9 - - [03/Dec/2021 15:25:56] "GET /hz HTTP/1.1" 200 -
10.92.0.9 - - [03/Dec/2021 15:26:17] "GET / HTTP/1.1" 200 -

make az-rg-del
```
