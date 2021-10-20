# Tails Server Helm Chart

This is a helm chart used to deploy a [tails server](https://github.com/bcgov/indy-tails-server), it is typically used with an ACA-Py issuer agent.  This chart is not normally used in isolation, typically part of an aca-py helm chart dependency.

## Installation

### Preparations

Add the chart repo:

```sh
helm repo add ssi  https://my-digi-id.github.io/ssi-helm-charts/
helm repo update
```

### To Install

First create an `tails_values.yaml` file, similar to below:

```yaml
# Default values for ssi-tails-server.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

## For multiple instances must make sure PVC is ReadWriteMany
replicaCount: 1

image:
  # Overrides the image tag whose default is the chart appVersion.
  tag: "1.1.0"

volumeSettings:
  # This is a storage class on IBM Cloud OpenShift Cluster
  storageClassName: 
  storageCapacity: 10Gi
  # Only change this if the docker image has been modified - this should be the default
  hostPath: "/home/indy/.indy_client"
  accessModes: 

tails:
  # Default is internal "0.0.0.0" addres, only change if required for new image build
  address:
  # Default is 6543 - only change if base image is exposing different port
  port:
  loglevel: "debug"

env: {}
```

Then execute the installation as such:

```sh
helm upgrade --install <RELEASE_NAME> ssi/ssi-tails-server -f tails_values.yaml
```

## Configuration

| Parameter                                                | Description                                                                                                                                                                                   | Default                                |
| -------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `replicaCount`                                           | Number of replicas                                                                                                                                                                            | `1`                                    |
| `image.repository`                                       | Image Repository                                                                                                                                                                              | `ghcr.io/my-digi-id/ssi-tails-server`        |
| `image.pullPolicy`                                       | Image Pull policy                                                                                                                                                                             | `IfNotPresent`                         |
| `image.tag`                                              | Image Tag                                                                                                                                                                                     | `"1.0.0"`                              |
| `tails.address`                                               | Host IP Address for tails server                                                                                                                                                                                      | `0.0.0.0`                                 |
| `tails.logLevel`                                               | loglevel                                                                                                                                                                                      | `info`                                 |
| `service.port`                                               | Image and service port. Only change if image is exposing a different port.                                                                                                                                                                                      | `6543`                                 |
| `imagePullSecrets`                                       | Pull secrets                                                                                                                                                                                   | `[]`                                  |
| `ingress.enabled`                                        | Enable ingress routes                                                                                                                                                                         | `true`                                 |
| `ingress.host`                                           | Ingress host URL, routes are created as subdomains of this host                                                                                                                               | `""`                                   |
| `ingress.annotations`                                    | Ingress Annotations                                                                                                                                                                           | `{}`                                   |
| `ingress.subdomainPrefix`                                | Subdomain prefix added to the routes (e.g. <prefix>indy.<host>)                                                                                                                               | `""`                                   |
| `ingress.tls`                                            | Array of tls secrets                                                                                                                                                                          | `[{secretName: tls-secret}]`           |
| `resources`                                              | Limit resources (see commments in values.yaml file)                                                                                                                                           | `{}`                                   |
| `autoscaling.enabled`                                    |                                                                                                                                                                                               | `false`                                |
| `autoscaling.minReplicas`                                |                                                                                                                                                                                               | `1`                                    |
| `autoscaling.maxReplicas`                                |                                                                                                                                                                                               | `100`                                  |
| `autoscaling.targetCPUUtilizationPercentage`             |                                                                                                                                                                                               | `80`                                   |
| `autoscaling.targetMemoryUtilizationPercentage`          |                                                                                                                                                                                               | `80`                                   |