# ACA-Py helm chart

This is a helm chart for installing the [aries cloud agent](https://github.com/hyperledger/aries-cloudagent-python).

Some key notes:

- It is assumed the values will be updated to allow creation of a PostreSQL server and an attached PVC
- For an issue a Tails Server service will also be created with an attached PVC

## Installation

### Preparations

Add the chart repo:

```sh
helm repo add ssi  https://my-digi-id.github.io/ssi-helm-charts/
helm repo update
```

### Issuer

Save these values to a `acapy-values.yaml` file and update the variables (for further cutomizations see Configuration section):

```yaml
apiKey: ACAPY_API_KEY
agentName: AGENT_NAME
genesisUrl: POOL_TRANSACTION_GENESIS_URL
isIssuer: true
schemaId: SCHEMA_ID
credentialName: CERDENTIAL_NAME
seed: ISSUER_SEED

webhook:
  url:  http://accreditation-controller:8080
  apikey: WEBHOOK_API_KEY

wallet: 
  key: WALLET_KEY

postgresql:
  postgresqlPostgresPassword: POSGRES_PASSWORD
  postgresqlPassword: POSGRES_PASSWORD

ingress:
  host: INGRESS_HOST
```

### Verifier

Save these values to a `acapy-values.yaml` file and update the variables (for further cutomizations see Configuration section):

```yaml
apiKey: ACAPY_API_KEY
agentName: AGENT_NAME
genesisUrl: POOL_TRANSACTION_GENESIS_URL
seed: VERIFIER_SEED
isIssuer: false

webhook:
  url:  http://accreditation-controller:8080
  apikey: WEBHOOK_API_KEY

wallet: 
  key: WALLET_KEY

postgresql:
  postgresqlPostgresPassword: POSGRES_PASSWORD
  postgresqlPassword: POSGRES_PASSWORD

ingress:
  host: INGRESS_HOST
```

## Install the chart

```sh
helm upgrade --install <YOUR_RELEASE_NAME> ssi/ssi-aca-py -f acapy-values.yaml
```

## Configuration

| Parameter                                                | Description                                                                                                                                                                                   | Default                                |
| -------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `genesisUrl`                                             | URL pointing to the Pool Transaction Genesis                                                                                                                                                  | `nil`                                  |
| `seed`                                                   | Seed of a monitoring DID on the network                                                                                                                                                       | `nil`                                  |
| `intervalSeconds`                                        | Polling interval of the monitoring                                                                                                                                                            | `30`                                   |
| `replicaCount`                                           | Number of replicas                                                                                                                                                                            | `1`                                    |
| `image.repository`                                       | Image Repository                                                                                                                                                                              | `ghcr.io/my-digi-id/ssi-aca-py`        |
| `image.pullPolicy`                                       | Image Pull policy                                                                                                                                                                             | `IfNotPresent`                         |
| `image.tag`                                              | Image Tag                                                                                                                                                                                     | `"1.0.0"`                              |
| `apiKey`                                                 | The Aca-Py Api key                                                                                                                                                                            | `""`                                   |
| `logLevel`                                               | loglevel                                                                                                                                                                                      | `info`                                 |
| `agentName`                                              | The name of the Agent.                                                                                                                                                                         | `Aries-Cloudagent`                     |
| `isIssuer`                                               | Specifiy if deploying for issuing or verifying (issuer has tails server bundled and creates credentials)                                                                                      | `false`                                 |
| `schemaId`                                               | Schema id of the used credential schema                                                                                                                                                       | `""`                                   |
| `credentialName`                                         | Name of the credential (if it exists on the ledger it must already exist in the wallet, otherwise use a name not existent on the ledger)                                                      | `default`                              |
| `seed`                                                   | The wallet did Seed (if runnning as issuer it has to be registered on the ledger)                                                                                                             | `""`                                   |
| `webhook.url`                                            | URL of the aca-py webhook                                                                                                                                                                     | `http://accreditation-controller:8080` |
| `webhook.apikey`                                         | The Webhook API key                                                                                                                                                                           | `"123"`                                |
| `tailsServerEndpoint`                                    | Optional tails server endpoint                                                                                                                                                                | `nil`                                  |
| `wallet.storageType`                                     | Wallet storage type (one of `postgres_storage` and `local`)                                                                                                                                   | `postgres_storage`                     |
| `wallet.key`                                             | The wallet key                                                                                                                                                                                | `""`                                   |
| `wallet.name`                                            | Name of the wallet                                                                                                                                                                            | `wallet`                               |
| `postgresql.enabled`                                     | Whether or not to use the bundled postgres (postgres values can be extended by any of [the Bitnami Postgres Chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql/) values) | `true`                                 |
| `postgresql.url`                                        | URL of the postgres server (leave blank when using internal postgres) )                                                                                                                       | `""`                                   |
| `postgresql.postgresqlPostgresPassword`                  | PostgreSQL admin Password                                                                                                                                                                     | `""`                                   |
| `postgresql.postgresqlUsername`                          | PostgreSQL username                                                                                                                                                                           | `ariescloudagent`                      |
| `postgresql.postgresqlPassword`                          | PostgreSQL Password                                                                                                                                                                           | `""`                                   |
| `postgresql.postgresqlDatabase`                          | PostgreSQL defualt Database (must be different from wallet name)                                                                                                                              | `ariescloudagent`                      |
| `postgresql.persistence.storageClass`                    | PVC Storage Class for PostgreSQL volume                                                                                                                                                       | `nil`                                  |
| `postgresql.volumePermissions.enabled`                   | Enable init container that changes volume permissions in the data directory (for cases where the default k8s runAsUser and fsUser values do not work)                                         | `false`                                |
| `postgresql.volumePermissions.securityContext.runAsUser` |                                                                                                                                                                                               | `auto`                                 |
| `postgresql.securityContext.enabled`                     | Enable security context                                                                                                                                                                       | `false`                                |
| `postgresql.shmVolume.chmod.enabled`                     | Set to `true` to chmod 777 /dev/shm on a initContainer (ignored if volumePermissions.enabled is `false`)                                                                                      | `false`                                |
| `postgresql.containerSecurityContext.enabled`            |                                                                                                                                                                                               | `false`                                |
| `ssi-tails-server.volumeSettings.storageClassName`       | Storage class for the tails server pvc                                                                                                                                                        | `nil`                                  |
| `ssi-tails-server.volumeSettings.storageCapacity`        | Storage capacity for the tails server pvc                                                                                                                                                     | `10Gi`                                 |
| `imagePullSecrets`                                       | Pull secrets                                                                                                                                                                                   | `[]`                                  |
| `ingress.enabled`                                        | Enable ingress routes                                                                                                                                                                         | `true`                                 |
| `ingress.exposeAdmin`                                    | Expose the acapy admin service as an ingress route                                                                                                                                            | `false`                                |
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
