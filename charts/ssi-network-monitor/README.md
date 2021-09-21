# SSI Network monitor

This charts provides a Prometheus metrics enpoint as well as a generic endpoint for a Prometheus Datasource

## Components

The Network monitor consists of 3 Containers

- monitor - A python script fetching The Network status
- transform - A Node.Js Application transorming the JSON data into Prometheus metrics
- Nginx - A webserver Provideing the API endpoint

## Endpoints:

`monitor-<deployment-name>:8080/` - Current data in JSON format
`monitor-<deployment-name>:8080/metrics` - extracted Metricx

## Configuration

| Parameter         | Description                                  | Default   |
| ----------------- | -------------------------------------------- | --------- |
| `genesisUrl`      | URL pointing of the Pool Transaction Genesis | `nil`     |
| `seed`            | Seed of a monitoring DID on the network      | `nil`     |
| `networkName`     | The network Name                             | `example` |
| `intervalSeconds` | Polling interval of the monitoring           | `30`      |
