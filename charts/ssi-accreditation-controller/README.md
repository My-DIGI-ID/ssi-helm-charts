# Accreditation Controller Helm Chart

This chart is for installing the accreditation controller, some key facts:

1. Install a mongo database with a PVC
   1. This will require a storage class to be specify in the values file
1. Variables will be defaulted, which will require modification and overrides

## Values Notes

The following sections will break down into the specific value groups that relate to the environment variables used to drive service behaviour.  All other settings are standard kubernetes helm settings and the relevant documentation should be referenced.  Values are saved in either a secrets object, config map or as a standard deployment variable.  If not explicitly mentioned it should be assumed to be in the deployment environment specification.

### Main Variables 

| Parameter | Description                | Environment Variable Mapping | Default |
| --------  | -------------------------- | ---------------------------- | ------- |
| `APIKey`  | They accreditation API Key | `ACCR_API_KEY`               |         |

### `dbssl` Group

| Parameter               | Description                                      | Environment Variable Mapping                | Default |
| ----------------------- | ------------------------------------------------ | ------------------------------------------- | ------- |
| `enabled`               | If `true` will expect SSL settings for mongodb   | `ACCR_MONGODB_SSL_ENABLED`                  | `false` |
| `sslKeyStore`           | The Key Storage name, stored in secrets object   | `ACCR_MONGODB_SSL_KEYSTORE`                 | `""`    |
| `sslKeyStorePassword`   | The Key password, stored in secrets object       | `ACCR_MONGODB_SSL_KEYSTORE_PASSWORD`        | `""`    |
| `sslTrustStore`         | The Trust Storage name, stored in secrets object | `ACCR_MONGODB_SSL_TRUSTSTORE`               | `""`    |
| `sslTrustStorePassword` | The Trust password, stored in secrets object     | `ACCR_MONGODB_SSL_TRUSTSTORE_PASSWORD`      | `""`    |
| `invalidHostAllowed`    | Used to configure hostname checking for mongo    | `ACCR_MONGODB_SSL_INVALID_HOSTNAME_ALLOWED` | `true`  |

### `keycloak` Group

| Parameter        | Description                                                  | Environment Variable Mapping          | Default                    |
| ---------------- | ------------------------------------------------------------ | ------------------------------------- | -------------------------- |
| `host`           | Keycloak URL, typical format `http(s)://<host>{port}/{path}` | `ACCR_ID_PROVIDER_HOST`               |                            |
| `port`           | Keycloak port, typically either `8080` or `8443`             | `ACCR_ID_PROVIDER_PORT`               | `8080`                     |
| `realm`          | Accreditation realm in keycloak server                       | `ACCR_ID_PROVIDER_REALM`              | `ssi-am-accreditation`     |
| `clientSecret`   | The `clientID` secret, stored in the secrets object          | `ACCR_ID_PROVIDER_ACCR_CLIENT_SECRET` |                            |
| `clientID`       | The keycloak client identifier                               | `ACCR_ID_PROVIDER_ACCR_CLIENT_ID`     | `accreditation-controller` |
| `sslTrustAll`    | Used to configure ssl trust between controller and keycloak  | `ACCR_ID_PROVIDER_SSL_TRUST_ALL`      | `true`                     |
| `verifyHostname` | Used to configure keycloak host name verification            | `ACCR_ID_PROVIDER_VERIFY_HOSTNAME`    | `false`                    |

### `agent` Group

The admin port is used by the controller to connect to the Aca-py agent, and also to execute the start-up initialisation script.  The client port is used for the container initialisation dependancy check.  Do not modify these unless the agent is running on different ports.

| Parameter       | Description                                             | Environment Variable Mapping | Default |
| --------------- | ------------------------------------------------------- | ---------------------------- | ------- |
| `APIKey`        | API Key for the aca-py issuer, stored in secrets object | `ACCR_AGENT_API_KEY`         |         |
| `webHookAPIKey` | Agent web-hook API Key, stored in secrets object        | `ACCR_AGENT_WEBHOOK_API_KEY` |         |
| `url`           | Issue aca-py agent url                                  | `ACCR_AGENT_API_URL`     |         |
| `adminPort`     | Administation port for agent, stored in config map      | `ACCR_AGENT_PORT_ADMIN`      | `11080` |
| `port`          | Client port for agent, used for initialising container  |                              | `11000` |

### `info` Group

| Parameter      | Description                                 | Environment Variable Mapping | Default                    |
| -------------- | ------------------------------------------- | ---------------------------- | -------------------------- |
| `contactEmail` | Contact email address, stored in config map | `ACCR_INFO_CONTACT_EMAIL`    |                            |
| `contactName`  | Contact name, stored in config map          | `ACCR_INFO_CONTACT_NAME`     |                            |
| `contactURL`   | Contact URL, stored in config map           | `ACCR_INFO_CONTACT_URL`      |                            |
| `description`  | Description, stored in config map           | `ACCR_INFO_DESCRIPTION`      |                            |
| `title `       | Title, stored in config map                 | `ACCR_INFO_TITLE`            | `Accreditation Controller` |

### `ui` Group

| Parameter  | Description                                 | Environment Variable Mapping | Default                                     |
| ---------- | ------------------------------------------- | ---------------------------- | ------------------------------------------- |
| `host`     | Accreditation UI URL, stored in config map  | `ACCR_UI_HOST`               | `http://<RELEASENAME>-ssi-accreditation-ui` |
| `port`     | Port for UI Host, stored in config map      | `ACCR_UI_PORT`               | `4200`                                      |
| `i18nPath` | Path to the i18n file, stored in config map | `ACCR_I18N_PATH`             | `/app/ui/`                                  |

### `cors` Group

| Parameter | Description                                           | Environment Variable Mapping | Default |
| --------- | ----------------------------------------------------- | ---------------------------- | ------- |
| `hostA`   | Enable cors for this host (e.g. http(s)://url[:port]) | `ACCR_ALLOWED_ORIGIN_HOST_A` |         |
| `hostB`   | Enable cors for this host (e.g. http(s)://url[:port]) | `ACCR_ALLOWED_ORIGIN_HOST_B` |         |
| `hostC`   | Enable cors for this host (e.g. http(s)://url[:port]) | `ACCR_ALLOWED_ORIGIN_HOST_C` |         |

### `guest` Group

| Parameter            | Description                                        | Environment Variable Mapping           | Default                                         |
| -------------------- | -------------------------------------------------- | -------------------------------------- | ----------------------------------------------- |
| `invitationRedirect` | Guest invitation redirect url, must include `{id}` | `ACCR_EMAIL_GUEST_INVITATION_REDIRECT` | `http://<releasename>:8080/guest/welcome/{id}"` |
| `lifetimeMS`         | Lifetime token in milliseconds                     | `ACCR_GUEST_TOKEN_LIFETIME_MS`         | `3000000`                                       |
| `definition`         | Guest credential for acapy agent and indy nodes    | `GUEST_CREDENTIAL_DEFINITION`          |                                                 |
| `name`               | Guest credential name for acapy agent and indy     | `GUEST_CREDENTIAL_NAME`                |                                                 |
| `schema`             | Guest db schema                                    | `GUEST_CREDENTIAL_SCHEMA`              |                                                 |
| `qrSize`             | QR Size                                            | `ACCR_GUEST_CONNECTION_QR_SIZE`        | `300`                                           |
| `fuzzyLimit`         | Guest fuzzy limit                                  | `ACCR_GUEST_BASIS_ID_FUZZY_LIMIT`      | `5`                                             |

### `basisid` Group

| Parameter        | Description                                       | Environment Variable Mapping          | Default |
| ---------------- | ------------------------------------------------- | ------------------------------------- | ------- |
| `devModeEnabled` | Development mode, only use for local docker usage | `ACCR_BASIS_ID_VERIFICATION_DEV_MODE` | `false` |
| `definition`     | BasisId credential for acapy agent and indy nodes | `BDR_BASIS_ID_CREDENTIAL_DEFINITION`  |         |
| `name`           | BasisId credential name for acapy agent           | `BDR_BASIS_ID_CREDENTIAL_NAME`        |         |
| `schema`         | BasisId db schema                                 | `BDR_BASIS_ID_SCHEMA`                 |         |
| `fuzzyThreshold` | Fuzzy Threshold                                   | `ACCR_FUZZY_LD_THRESHOLD`             | `50`    |

### `employee` Group

| Parameter    | Description                                        | Environment Variable Mapping       | Default |
| ------------ | -------------------------------------------------- | ---------------------------------- | ------- |
| `name`       | Employee name for acapy agent and indy nodes.      | `EMPLOYEE_CREDENTIAL_NAME`         |         |
| `definition` | Employee definition for acapy agent and indy nodes | `EMPLOYEE_CREDENTIAL_DEFINITION`   |         |
| `schema`     | Employee db schema                                 | `EMPLOYEE_CREDENTIAL_SCHEMA`       |         |
| `qrSize`     |  QR Size                                           | `ACCR_EMPLOYEE_CONNECTION_QR_SIZE` | `300`   |

### `swagger` Group

| Parameter | Description                                                                               | Environment Variable Mapping       | Default |
| --------- | ----------------------------------------------------------------------------------------- | ---------------------------------- | ------- |
| `host`    | Authorisation host for swagger ui page, must be format `"http(s)://host({port})/{path}/"` | `ACCR_SWAGGER_UI_ID_PROVIDER_HOST` |         |

### `ssl` Group

| Parameter             | Description                            | Environment Variable Mapping            | Default |
| --------------------- | -------------------------------------- | --------------------------------------- | ------- |
| `enabled`             | Enables SSL for the controller service | `ACCR_CONTROLLER_SSL_ENABLED`           | `false` |
| `sslKeyStore`         | SSL Keystore name                      | `ACCR_CONTROLLER_SSL_KEYSTORE`          |         |
| `sslKeyStorePassword` | SSL Keystore password                  | `ACCR_CONTROLLER_SSL_KEYSTORE_PASSWORD` |         |
| `sslKeyStoreType`     | SSL Keystore type                      | `ACCR_CONTROLLER_SSL_KEYSTORE_TYPE`     |         |
| `sslKeyAlias`         | SSL Key alias                          | `ACCR_CONTROLLER_SSL_KEY_ALIAS`         |         |

### `mongodb` Group

The full list of possible mongoDB helm values can be found at [Bitnami MongoDB Chart](https://github.com/bitnami/charts/tree/master/bitnami/mongodb/#installing-the-chart).  The key values, and there mappings, are detailed below.  By default the mongoDB chart is executed, unless the `enabled` variable is set to `false`, in which case all related values must point to a valid mongoDB database hosted elsewhere (e.g. cloud managed service).

| Parameter                  | Description                                                                              | Environment Variable Mapping  | Default                 |
| -------------------------- | ---------------------------------------------------------------------------------------- | ----------------------------- | ----------------------- |
| `enabled`                  | If `false` mongoDB chart is not executed                                                 | `ACCR_CONTROLLER_SSL_ENABLED` | `false`                 |
| `host`                     | The host for mongoDB, if using chart leave blank                                         | `ACCR_MONGODB_HOST`           | `<releasename>-mongodb` |
| `auth.rootUser`            | MongoDB Root username                                                                    | `ACCR_MONGODB_USERNAME`       | `root`                  |
| `auth.rootPassword`        | MongoDB Root password, stored in secret                                                  | `ACCR_MONGODB_PASSWORD`       |                         |
| `auth.username`            | MongoDB User, needed for chart creation. Not used by controller                          |                               | `mongouser`             |
| `auth.password`            | MongoDB password, needed for chart creation. Not used by controller, but must have value |                               |                         |
| `auth.database`            | MongoDB database, stored in configmap                                                    | `ACCR_MONGODB_DB_NAME`        | `admin`                 |
| `auth.authDatabase`        | MongoDB authorisation database, stored in configmap                                      | `ACCR_MONGODB_AUTH_DB_NAME`   | `admin`                 |
| `persistence.storageClass` | Kubernetes storage class for PVC                                                         |                               |                         |
| `persistence.size`         | PVC storage size to request                                                              |                               | `10Gi`                  |

### Defaulted Variables

These are typically expected to be left as defaults.  However, if they require being overridden then add the variables explicitly to the `overrides` value group, for example:

```yaml
overrides:
  ACCR_MONGODB_PORT: 27018
```

Because of the dependancy on servivces such as keycloak, image build there are several variables which are not explicitly overwritten, or have values mappings.  The following is a list of those variables.

| Variable                                | Description                                                                                      | Default                                                            |
| --------------------------------------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------ |
| ACCR_EMAIL_TEMPLATE_GUEST_INVITATION    | Use `overrides.ACCR_EMAIL_TEMPLATE_GUEST_INVITATION` to override location, must be in image      | `/data/resources/templates/guest-invitation-email-template.html`   |
| ACCR_EMAIL_TEMPLATE_EMPLOYEE_INVITATION | Use `overrides.ACCR_EMAIL_TEMPLATE_EMPLOYEE_INVITATION ` to override location, must be in image  | `/data/resources/templates/employee-invitation-email-template.html`| 
| ACCR_ID_PROVIDER_PERMISSIONS_PATH       | This is a standard keycloak path, will only change for specific changes to authentication        | `auth/realms/{realm}/protocol/openid-connect/token`                |
| ACCR_ID_PROVIDER_TOKEN_PATH             | This is a keycloak path and will only be changed if the id provider is changed                   | `auth/realms/{realm}/protocol/openid-connect/token/introspect`     |
| ACCR_MONGODB_PORT                       | Defaults to `27017`, override using `overrides.ACCR_MONGODB_PORT`                                | `27017`                                                            |
| SPRING_PROFILES_ACTIVE                  | This should nearly always be `localdocker`                                                       | `localdocker`                                                      |
| ACCR_JWT_USER_IDENTIFIER_ENTRY_NAME     | This will only change if keycloak is not used                                                    | `preferred_username`                                               |
| AGENT_API_KEY_HEADER_NAME               | Use `overrides.AGENT_API_KEY_HEADER_NAME` to override                                            | `X-API-Key`                                                        |
| ACCR_API_KEY_HEADER_NAME                | Use `overrides.ACCR_API_KEY_HEADER_NAME` to override                                             | `X-API-Key`                                                        |

### `env` Group

This is a section in which custom variables can be inserted and added to the deployment resource.  It is intended to be used if the image has been rebuilt with additional variables, for example the source code has been downloaded and modified for a custom usage.  This allows the main helm chart to be used with the ability to support simple custom changes.  An example usage would be:

```yaml
env:
  MYCUSTOMVARIABLE: "hello"
```

### `initScript` Group

The Accreditation Controller helm chart has an initialisation script file, `accreditation_init_script.sh`, which is used to create the employee and guest credentials and schema.  This is necessary for the controller to function properly.  To disable it's execution you can set `enabled` to `false`.  The `AGENT_URL` variable must be constructed correctly, the example below shows how it can be constructed.

```yaml
initScript:
  enabled: true
  # script: |
  #   echo "Initialized with script from values";
  #   echo "WEBHOOK_URL: $WEBHOOK_URL";
  scriptFile: accreditation_init_script.sh
  env:
    AGENT_URL: http://${ACCR_RELEASE_NAME}-agent-ssi-aca-py:${ACCR_AGENT_PORT_ADMIN}
  # Define which values should be passed as an environment variable
  envValues:
    EMPLOYEE_CREDENTIAL_SCHEMA: employee.schema
    EMPLOYEE_CREDENTIAL_NAME: employee.name
    GUEST_CREDENTIAL_SCHEMA: guest.schema
    GUEST_CREDENTIAL_NAME: guest.name
    AGENT_API_KEY: agent.APIKey
```    
